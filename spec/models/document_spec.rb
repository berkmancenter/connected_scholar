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

  describe "#active_citations" do
    subject do
      Document.create! :name => 'foobar'
    end

    let :resource do
      Resource.create! :document => subject
    end

    context "with no active resource" do
      it "should have no active citation" do
        resource.active?.should be_false
        subject.active_sources.size.should == 0
        subject.active_citations.size.should == 0
      end
    end

    context "with one active resource" do
      before do
        resource.activate!
        resource.default_citation!
      end

      it "should have one active citation" do
        resource.active?.should be_true
        subject.active_sources.size.should == 1
        subject.active_citations.size.should == 1

        subject.active_citations.first["citation_text"].should == resource.default_citation!
        subject.active_citations.first["resource_id"].should == resource.id
      end
    end

  end

  describe "#etherpad_password" do
    subject do
      Document.create! :name => 'foobar'
    end

    it "should have an etherpad_password" do
      subject.etherpad_password.should_not be_nil
    end
  end

  describe "#add_citation" do 
    subject do
      Document.create! :name => 'foobar'
    end

    let :resource do
      Resource.create! :document => subject, :active => true, :publication_date => Date.today
    end

    context "when citation does not exist" do 
      it "should add the citation to the list of citations" do 
         subject.add_citation("(Foo 2011)", resource.id)  
         subject.active_citations.size.should == 1
         resource.citations.size.should == 1
      end
    end
  end
end
