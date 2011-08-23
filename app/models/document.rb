class Document < ActiveRecord::Base
  has_many :comments, :dependent => :destroy
  has_many :recommended_resources, :class_name => 'Resource', :dependent => :destroy
  has_many :active_sources, :class_name => 'Resource', :dependent => :destroy
end
