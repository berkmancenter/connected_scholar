require 'spec_helper'

describe Citation do
  let :document do
    Document.create! :name => 'foobar'
  end

  let :resource do
    Resource.create! :document => document
  end

  describe "#default" do
    describe "when this is the first citation for a resource" do
      it "should save if its the default" do
        resource.citations.size.should == 0
        resource.citations.create!(:resource => resource, :citation_text => "(Smith 1999)", :default => true)
        resource.citations.size.should == 1
      end

      it "should error if its not the default" do
        resource.citations.size.should == 0
        expect do
          resource.citations.create!(:resource => resource, :citation_text => "(Smith 1999)", :default => false)
        end.to raise_error(ActiveRecord::RecordInvalid)
      end

      it "should error if its default is not set" do
        resource.citations.size.should == 0
        expect do
          resource.citations.create!(:resource => resource, :citation_text => "(Smith 1999)")
        end.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    describe "when this is the second citation for a resource" do
      before do
        resource.title = "Hello World"
        resource.creators << "John Doe"
        resource.publication_date = Date.parse('2000-01-01')
        resource.save!
        resource.default_citation!
        resource.save!
      end

      it "should save if its not the default" do
        resource.citations.size.should == 1
        resource.citations.create!(:resource => resource, :citation_text => "(Smith 1999)", :default => false)
        resource.citations.size.should == 2
      end

      it "should error if its the default" do
        resource.citations.size.should == 1
        expect do
          resource.citations.create!(:resource => resource, :citation_text => "(Smith 1999)", :default => true)
        end.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe "#make_default!" do
    before do
      resource.title = "Hello World"
      resource.creators << "John Doe"
      resource.publication_date = Date.parse('2000-01-01')
      resource.save!
      resource.default_citation!
      resource.save!
    end

    it "should do nothing if its already the default" do
      old_default = resource.citations.first
      c = resource.citations.create!(:resource => resource, :citation_text => "(Smith 1999)", :default => false)
      old_default.make_default!
      c.default.should be_false
      old_default.reload.default.should be_true
    end

    it "should atomically swap default value" do
      old_default = resource.citations.first
      c = resource.citations.create!(:resource => resource, :citation_text => "(Smith 1999)", :default => false)
      c.make_default!
      c.default.should be_true
      old_default.reload.default.should_not be_true
    end

    it "should not change values if there is an error" do
      old_default = resource.citations.first
      c = resource.citations.create!(:resource => resource, :citation_text => "(Smith 1999)", :default => false)

      def c.save!
        raise "Fake Error"
      end
      
      expect {
        c.make_default!
      }.to raise_error(StandardError)

      c.reload.default.should be_false
      old_default.reload.default.should be_true
    end

    it "should promote the other one if the default is destroyed" do
      old_default = resource.citations.first
      c = resource.citations.create!(:resource => resource, :citation_text => "(Smith 1999)", :default => false)

      old_default.destroy

      c.reload.default.should be_true
    end

    it "should not have a default if the only citation is destroyed" do
      old_default = resource.citations.first
      old_default.destroy
      resource.citations.size.should == 0
    end
  end
end
