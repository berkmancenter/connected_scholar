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

  def author_id
    @author_id ||= create_author_if_not_exists_for(self)
  end

  def author_id=(value)
    @author_id = value
  end

end
