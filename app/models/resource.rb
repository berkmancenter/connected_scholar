require 'bibtex'
require 'citeproc'
class Resource < ActiveRecord::Base
  has_many :citations
  has_many :quotations
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

  def format(options={})
    _options = {:style => 'mla', :mode => :citation}
    _options.merge!(options)
    _options[:style] = File.join(Rails.root, 'public', 'vendor', citation_dir, "#{_options[:style].to_s}.csl")
    CiteProc.process(bibtex.to_citeproc, _options).first
  end

  def bibtex
    year = self.publication_date ? self.publication_date.year : ""
    bib = ::BibTeX::Entry.new({
      :author => self.creators.join(' and '),
      :year => "#{year}",
      :publisher => self.publisher,
      :title => self.title,
      :address => self.pub_location
    })

    return bib
  end

  private

  def citation_dir
    @@citation_dir ||= YAML.load_file('config/citation_styles.yml')['dir']
  end

  def default_citation
    format(:mode => :citation, :style => self.document.citation_format.to_s)      
  end
end
