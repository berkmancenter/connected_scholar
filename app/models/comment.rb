class Comment < ActiveRecord::Base
  
  has_one :author, :class_name => "User"
  has_one :document
end
