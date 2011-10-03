class Citation < ActiveRecord::Base
  belongs_to :resource
  has_one :document, :through => :resource

  validates_uniqueness_of :default, :scope => :resource_id, :if => Proc.new {|citation| citation.default}
end
