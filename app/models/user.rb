class User < ActiveRecord::Base
  include EtherpadUtil

  has_and_belongs_to_many :groups
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me

  validates_presence_of :name
  validates_uniqueness_of :name, :email, :case_sensitive => false

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

  def admin?
    true
  end
end
