require 'spec_helper'

describe Resource do
  let :document do
    Document.create! :name => 'foobar'
  end

  subject do
    Resource.create! :document => document
  end

  describe "#citations" do
    describe "when there is already a default citation" do
      before do
        subject.title = "Hello World"
        subject.creators << "John Doe"
        subject.publication_date = Date.parse('2000-01-01')
        subject.save!
        subject.default_citation!
        subject.save!
      end

      it "should accept another" do
        subject.citations.create!(:resource => subject, :citation_text => "(Smith 1999)")
        subject.citations.size.should == 2
      end
    end
  end

  describe "#default_citation!" do
    context "when no other citations exist" do
      before do
        subject.title = "Hello World"
        subject.creators << "John Doe"
        subject.publication_date = Date.parse('2000-01-01')
        subject.save!
      end

      it "should equal '(Doe 2000)'" do
        subject.default_citation!.should == "(Doe 2000)"
        subject.citations.size.should == 1
        subject.citations.first.citation_text.should == "(Doe 2000)"
        subject.citations.first.default.should be_true
        subject.citations.first.resource.id.should == subject.id
      end
    end
    
    context "when the default exists" do
      before do
        subject.title = "Hello World"
        subject.creators << "John Doe"
        subject.publication_date = Date.parse('2000-01-01')
        subject.save!
        subject.default_citation!
        subject.save!
      end

      it "should equal '(Doe 2000)'" do
        subject.default_citation!.should == "(Doe 2000)"
        subject.citations.size.should == 1
        subject.citations.first.citation_text.should == "(Doe 2000)"
        subject.citations.first.default.should be_true
        subject.citations.first.resource.id.should == subject.id
      end
    end


    describe "when another resource has the same default citation" do
      describe "and the document is the same" do
        before do
          r = Resource.create! :document => document,
                               :title => "Goodbye World",
                               :creators => ["John Doe"],
                               :publication_date => Date.parse('2000-01-01')
          r.default_citation!
          r.save!

          subject.title = "Hello World"
          subject.creators << "John Doe"
          subject.publication_date = Date.parse('2000-01-01')
          subject.save!
        end

        it "should equal '(Doe, Hello World 2000)'" do
          subject.default_citation!.should == "(Doe, \"Hello World\" 2000)"
          subject.citations.size.should == 1
          subject.citations.first.citation_text.should == "(Doe, \"Hello World\" 2000)"
          subject.citations.first.default.should be_true
          subject.citations.first.resource.id.should == subject.id
        end
      end

      describe "and the document is different" do
        before do
          r = Resource.create! :document => Document.create!(:name => "something else"),
                               :title => "Goodbye World",
                               :creators => ["John Doe"],
                               :publication_date => Date.parse('2000-01-01')
          r.default_citation!
          r.save!

          subject.title = "Hello World"
          subject.creators << "John Doe"
          subject.publication_date = Date.parse('2000-01-01')
          subject.save!
        end

        it "should equal '(Doe 2000)'" do
          subject.default_citation!.should == "(Doe 2000)"
          subject.citations.size.should == 1
          subject.citations.first.citation_text.should == "(Doe 2000)"
          subject.citations.first.default.should be_true
          subject.citations.first.resource.id.should == subject.id
        end
      end
    end
  end
end
