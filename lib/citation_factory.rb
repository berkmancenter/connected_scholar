module CitationFactory
  TYPES={ :mla => MlaCitation }

  def self.citation_formatter(type)
    return TYPES[type] if TYPES[type]
    return MlaCitation
  end
end