require 'spec_helper'

describe Document do
  describe "#name" do

    context "when name is foobar" do
      subject do
        Document.create! :name => 'foobar'
      end

      it "should have the name foobar" do
        subject.name.should == 'foobar'
      end
    end
  end

  describe "#add_contributor_by_email" do

    context "when a contributor is added" do
      let :owner do
        User.create! :name => "Test User", :email => 'test@test.com', :password => 'password', :password_confirmation => 'password'
      end

      let :contributor do
        User.create! :name => "Contrib User", :email => 'contrib@test.com', :password => 'password', :password_confirmation => 'password'
      end

      subject do
        Document.create! :name => 'foobar', :owner => owner
      end

      before do
        subject.add_contributor_by_email(contributor.email).should be_true
      end

      it "should be shared" do
        docs = Document.find_shared_documents(contributor)
        docs.should include(subject)
      end
      
      it "should have a contributor" do
        subject.contributors.size.should == 1
        subject.contributors.should include(contributor)
      end
    end
  end

  describe "#remove_contributor" do

    context "when a contributor is removed" do
      let :owner do
        User.create! :name => "Test User", :email => 'test@test.com', :password => 'password', :password_confirmation => 'password'
      end

      let :contributor do
        User.create! :name => "Contrib User", :email => 'contrib@test.com', :password => 'password', :password_confirmation => 'password'
      end

      subject do
        Document.create! :name => 'foobar', :owner => owner
      end

      before do
        subject.add_contributor_by_email(contributor.email)
        subject.reload
        subject.remove_contributor(contributor)
      end

      it "should not be shared" do
        docs = Document.find_shared_documents(contributor)
        docs.size.should == 0
      end

      it "should have not contributor" do
        subject.contributors.size.should == 0
      end
    end
  end
end
