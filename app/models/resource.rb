class Resource < ActiveRecord::Base
  has_many :citations
  belongs_to :document
  serialize :creators, Array
  serialize :desc_subject, Array
  serialize :id_isbn, Array

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
    # TODO expand this to different formats
    # format (Smith 2011)

    citation = "(#{author_for_citation} #{pub_year})"
    if Citation.includes(:resource).where(
            :resources => {:document_id => self[:document_id]},
            :citation_text => citation)
          .where("resource_id <> ?", self.id)
          .exists?
      "(#{author_for_citation}, \"#{title}\" #{pub_year})"
    else
      citation
    end
  end

  def pub_year
    publication_date ? publication_date.year : ""
  end

  def author_for_citation
    if !creators.blank? && creators.size > 0
      creator = creators.first
      creator.index(",").nil? ? creator.split(" ").last : creator[0, creator.index(",")]
    else
      ""
    end
  end
end
