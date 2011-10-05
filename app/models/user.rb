class User < ActiveRecord::Base
  include EtherpadUtil

  serialize :preferences, Hash

  has_and_belongs_to_many :groups
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me

  validates_presence_of :name
  validates_uniqueness_of :name, :email, :case_sensitive => false

  # i can't remember if i decided to keep this or not. it isn't breaking anything.  but if its not necessary we should
  # dump it.
  after_find do |u|
    u.preferences ||= {}
  end

  def etherpad_author_id
    @etherpad_author_id ||= create_author_if_not_exists_for(self)
  end

  def active_for_authentication?
    approved?
  end

  def inactive_message
    !approved? ? :unapproved : super
  end

  def approve!
    self.approved = true
  end

  def promote!
    self.admin = true
  end

  def demote!
    self.admin = false
  end

  def destroy!
    self.groups.each do |g|
      g.destroy
    end
    Document.destroy_all(:owner_id => self.id)
    self.destroy
  end

  def send_confirmation_instructions
    # nope
  end
end
