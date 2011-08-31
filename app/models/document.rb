class Document < ActiveRecord::Base
  include EtherpadUtil

  has_many :comments, :dependent => :destroy
  has_many :recommended_resources, :class_name => 'Resource', :dependent => :destroy
  has_many :active_sources, :class_name => 'Resource', :dependent => :destroy

  belongs_to :owner, :class_name => 'User'
  belongs_to :group

  # for now just a unique name because we are creating public pads, but once we hook up with the etherpad services for
  # creating private pads for a user/group, then we will fix this.
  validates_uniqueness_of :name #, :scope => :owner_id

  def etherpad_group_id
    @etherpad_group_id ||= create_group_if_not_exists_for(self)
  end

  def can_be_viewed_by(user)
    self.owner == user || (self.group && self.group.users && self.group.users.include?(user))
  end
end
