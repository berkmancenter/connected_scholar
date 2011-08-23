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
end
