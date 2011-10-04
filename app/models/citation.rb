class Citation < ActiveRecord::Base
  belongs_to :resource
  has_one :document, :through => :resource

  validates_uniqueness_of :default, :scope => :resource_id, :if => Proc.new {|citation| citation.default}
  validates_uniqueness_of :citation_text, :scope => :resource_id

  validate :ensure_default

  before_destroy :ensure_not_default

  def make_default!
    if !default
      default_cit = Citation.where(:default => true, :resource_id => resource_id).first
      transaction do
        default_cit.default = false
        self.default = true
        default_cit.save!
        self.save!
      end
    end
  end

  private

  def ensure_default
    if !default and Citation.where(:default => true, :resource_id => resource_id).empty?
      errors.add(:default, "There must be one default Citation per Resource")
    end
  end

  def ensure_not_default
    if default
      c = Citation.where(:default => false, :resource_id => resource_id).first
      c.make_default! if c
    end
  end
end
