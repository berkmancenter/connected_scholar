class Comment < ActiveRecord::Base
  
  belongs_to :author, :class_name => "User"
  belongs_to :document

  def read_by(user)
    self.is_read = true if self.document.owner == user
  end
end
