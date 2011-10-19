require 'bibtex'
require 'citeproc'
module CitationFormatter

  def self.format(resource, options={:style => :mla, :mode => :citation})
  	CiteProc.process(resource.to_citeproc, options)
  end
end