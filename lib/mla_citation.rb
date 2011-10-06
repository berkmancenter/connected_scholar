class MlaCitation

  def self.format(resource)
    author = author_for_citation(resource)
    year = pub_year(resource)
    title = resource.title
    ["(#{author} #{year})",
     "(#{author}, \"#{title}\" #{year})"
    ]
  end

  def self.pub_year(resource)
    resource.publication_date ? resource.publication_date.year : ""
  end

  def self.author_for_citation(resource)
    if !resource.creators.blank? && resource.creators.size > 0
      creator = resource.creators.first
      creator.index(",").nil? ? creator.split(" ").last : creator[0, creator.index(",")]
    else
      ""
    end
  end
end