class Resource < ActiveRecord::Base
  has_many :citations
  belongs_to :document
  serialize :creators, Array
  serialize :desc_subject, Array
  serialize :id_isbn, Array
  serialize :links, Array

  belongs_to :recommended_by, :class_name => 'User'

  scope :active_sources, lambda {
    where(:active => true)
  }
  scope :recommended_resources, lambda {
    where(:active => false)
  }

  def activate!
    self.active = true
    self.save!
  end

  # This method needs to return quickly because its called on the drag-and-drop.
  # So don't load it up with unnessecary DB calls.
  #
  def default_citation!
    d = self.citations.where(:default => true).first

    if d
      d.citation_text
    else
      c = default_citation
      self.citations.create!(:resource => self, :citation_text => c, :default => true)
      c
    end
  end

  private

  def default_citation
    formatter = CitationFactory.citation_formatter(self.document.citation_format)
    citations = formatter.format(self)
    citations.each do |citation|
      unless(Citation.includes(:resource).where(
            :resources => {:document_id => self[:document_id]},
            :citation_text => citation)
          .where("resource_id <> ?", self.id)
          .exists?)
        return citation
      end
    end        
  end
end
