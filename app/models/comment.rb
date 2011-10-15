class Comment < ActiveRecord::Base
  
  belongs_to :author, :class_name => "User"
  belongs_to :document

  before_create :check_if_author_is_owner

  def read_by(user)
    self.is_read = true if self.document.owner == user
    self.save
  end

  private

  def check_if_author_is_owner
    self.is_read = true if self.author == self.document.owner
  end
end
