class Resource < ActiveRecord::Base
  belongs_to :document

  serialize :creators, Array
  serialize :desc_subject, Array
  serialize :id_isbn, Array
end
