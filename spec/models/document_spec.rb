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
    let :user do
      User.create! :name => "Test User", :email => 'test@test.com', :password => 'password', :password_confirmation => 'password'
    end
    subject do
      Document.create! :name => 'foobar', :owner => user
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

  describe "#refresh_resources" do
    let :owner do
      User.create! :name => "Test User", :email => 'test@test.com', :password => 'password', :password_confirmation => 'password'
    end

    subject do
      Document.create! :name => 'foobar', :owner => owner
    end

    let :resource do
      Resource.create! :document => subject, :active => false
    end

    before do
      resource.title = "Hello World"
      resource.creators << "John Doe"
      resource.publication_date = Date.parse('2000-01-01')
      resource.save!
      resource.default_citation!
      resource.save!
    end

    it "activates the resource" do
      subject.stub!(:get_pad_text).and_return(<<-TXT)
        It was the best of times, it was the blurst of times #{resource.default_citation!}.
      TXT

      resource.active.should be_false
      subject.refresh_resources!
      resource.reload
      resource.active.should be_true
    end

    it "deactivates the resource" do
      subject.stub!(:get_pad_text).and_return(<<-TXT)
        It was the best of times, it was the blurst of times.
      TXT

      resource.activate!

      resource.active.should be_true
      subject.refresh_resources!
      resource.reload
      resource.active.should be_false
    end

    it "keeps the resource active" do
      subject.stub!(:get_pad_text).and_return(<<-TXT)
        It was the best of times, it was the blurst of times #{resource.default_citation!}.
      TXT

      resource.activate!

      resource.active.should be_true
      subject.refresh_resources!
      resource.reload
      resource.active.should be_true
    end

    it "keeps the resource unactive" do
      subject.stub!(:get_pad_text).and_return(<<-TXT)
        It was the best of times, it was the blurst of times.
      TXT

      resource.active.should be_false
      subject.refresh_resources!
      resource.reload
      resource.active.should be_false
    end
  end
end
