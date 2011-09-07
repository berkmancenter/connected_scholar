class Resource < ActiveRecord::Base
  belongs_to :document
  serialize :creators, Array
  serialize :desc_subject, Array
  serialize :id_isbn, Array
  
  def default_citation
    # TODO expand this to different formats
    # format (Smith 2011)
    "(#{author_for_citation} #{pub_year})"
  end
  
  private
  
  def pub_year
    publication_date ? publication_date.year : ""
  end
  def author_for_citation
    if !creators.blank? && creators.size > 0
      creator = creators.first
      creator[0, creator.index(",")]
    else
      ""
    end
  end
end
