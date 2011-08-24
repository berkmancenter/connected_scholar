class Document < ActiveRecord::Base
  has_many :comments, :dependent => :destroy
  has_many :recommended_resources, :class_name => 'Resource', :dependent => :destroy
  has_many :active_sources, :class_name => 'Resource', :dependent => :destroy

  belongs_to :owner, :class_name => 'User'

  # for now just a unique name because we are creating public pads, but once we hook up with the etherpad services for
  # creating private pads for a user/group, then we will fix this.
  validates_uniqueness_of :name #, :scope => :owner_id
end
