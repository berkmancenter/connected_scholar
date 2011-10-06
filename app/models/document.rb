class Document < ActiveRecord::Base
  include EtherpadUtil

  has_many :comments, :dependent => :destroy
  has_many :resources, :dependent => :destroy

  belongs_to :owner, :class_name => 'User'
  belongs_to :group

  validates_presence_of :name, :etherpad_name

  validates_uniqueness_of :etherpad_name, :scope => :owner_id
  validates_uniqueness_of :name, :scope => :owner_id

  before_create :init_group, :set_etherpad_password

  before_validation :set_etherpad_name

  scope :my_documents, lambda {|user| {:conditions => {:owner_id => user.id}}}

  def active_sources
    self.resources.active_sources
  end

  def active_citations
    active_sources.map{|as| as.citations }.flatten.map{|c| {"resource_id" => c.resource_id, "citation_text" => c.citation_text}}
  end

  def recommended_resources
    self.resources.recommended_resources
  end
  
  def self.find_shared_documents(user)
    groups = Group.joins(:users).where(:users => {:id => user.id})
    groups.map(&:document)
  end

  def add_contributor_by_email(email)
    if email == owner.email
      yield :cannot_add_owner
    else
      contributor = User.where(:email => email).first
      if contributor.nil?
        yield :unrecognized_email
      else
        unless self.group.users.exists?(:id => contributor.id)
          self.group.users << contributor
        end
        return true
      end
    end
    false
  end

  def remove_contributor(user)
    self.group.users.delete(user)
  end

  def contributors
    group.users
  end

  def etherpad_group_id
    @etherpad_group_id ||= create_group_if_not_exists_for(self)
  end

  def can_be_viewed_by(user)
    self.owner == user || (self.group && self.group.users && self.group.users.include?(user))
  end

  def pad_id
    "#{etherpad_group_id}$#{CGI::escape(etherpad_name)}"
  end

  def citation_format
    # TODO lookup in user preferences
    :mla
  end

  private

  def init_group
    self.group = Group.create
  end

  def set_etherpad_password
    self.etherpad_password = SecureRandom.hex(13)
  end

  def set_etherpad_name
    if etherpad_name.nil?
      write_attribute(:etherpad_name, self.name.gsub(' ', '_'))
    else
      if etherpad_name_changed?
        raise "Etherpad name is read-only!"
      end
    end
  end
end
