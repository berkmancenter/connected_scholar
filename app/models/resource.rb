
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

  def deactivate!
    self.active = false
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

  

  def to_citeproc
    bibtex.to_citeproc
  end

  private

  def bibtex
    year = self.publication_date ? self.publication_date.year : ""
    bib = ::BibTeX::Entry.new({
      :author => self.creators.join(' and '),
      :year => "#{year}",
      :publisher => self.publisher,
      :title => self.title,
      :address => self.pub_location
    })
    #necessary in bibtex 2.0.0
    #can remove for bibtex 2.0.1
    bib.parse_names
    return bib
  end

  def default_citation
    CitationFormatter.format(self, :mode => :citation, :style => self.document.citation_format.to_s)      
  end
end
