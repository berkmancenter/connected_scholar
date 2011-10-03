class Citation < ActiveRecord::Base
  belongs_to :resource
  has_one :document, :through => :resource

  validates_uniqueness_of :default, :scope => :resource_id, :if => Proc.new {|citation| citation.default}
  validates_uniqueness_of :citation_text, :scope => :resource_id

  validate :ensure_default

  private

  def ensure_default
    if !default and Citation.where(:default => true, :resource_id => resource_id).empty?
      errors.add(:default, "There must be one default Citation per Resource")
    end
  end
end
