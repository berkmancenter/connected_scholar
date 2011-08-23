require 'spec_helper'

describe Comment do
  let :document do
    Document.create! :name => 'foobar'
  end

  let :user do
    User.create! :name => "Test User", :email => 'test@test.com', :password => 'password', :password_confirmation => 'password'
  end

  subject do
    Comment.create! :comment_text => 'this is a comment', :author => user, :document => document
  end
  
  describe "#document" do
    it "should be associated with a document" do
      subject.document.should  == document
    end
  end

  describe "#author" do
    it "should be associated with a document" do
      subject.author.should  == user
    end
  end
end
