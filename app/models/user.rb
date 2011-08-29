class User < ActiveRecord::Base
  include EtherpadUtil
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me

  #validates_presence_of :name
  validates_uniqueness_of :name, :email, :case_sensitive => false

  after_create :create_etherpad_author

  def create_etherpad_author
    create_author_if_not_exists_for(self)
  end
end
