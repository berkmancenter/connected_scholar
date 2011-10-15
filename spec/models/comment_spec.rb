require 'spec_helper'

describe Comment do
  let :owner do
    User.create! :name => "Doc Owner", :email => 'owner@test.com', :password => 'password', :password_confirmation => 'password'
  end

  let :document do
    Document.create! :name => 'foobar', :owner => owner
  end

  let :user do
    User.create! :name => "Test User", :email => 'test@test.com', :password => 'password', :password_confirmation => 'password'
  end

  subject do
    Comment.create! :comment_text => 'this is a comment', :author => user, :document => document
  end
  
  describe "#document" do
    it "is associated with a document" do
      subject.document.should  == document
    end
  end

  describe "#author" do
    it "is associated with a document" do
      subject.author.should  == user
    end
  end

  describe "#is_read" do
    it "is true when doc owner reads" do
      subject.is_read.should be_false
      subject.read_by(owner)
      subject.is_read.should be_true
    end

    it "is true when user reads" do
      subject.is_read.should be_false
      subject.read_by(user)
      subject.is_read.should be_false
    end
  end
end
