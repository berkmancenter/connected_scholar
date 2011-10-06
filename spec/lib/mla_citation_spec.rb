require 'spec_helper'

describe MlaCitation do
  let :formatter do
    CitationFactory.citation_formatter(:mla)
  end

  let :user do
    User.create! :name => "Test User", :email => 'test@test.com', :password => 'password', :password_confirmation => 'password'
  end

  let :document do
    Document.create! :name => 'foobar', :owner => user
  end

  let :resource do
    Resource.create! :document => document, :creators => ["Smith, John"], :title => "Test Resource", :publication_date => Date.new(2011, 1, 1)
  end

  describe "#format" do 
    it "should return 2 formats" do 
      formatter.format(resource).size.should == 2
    end
    it "first format should be (Smith 2011)" do
      formatter.format(resource).first.should == "(Smith 2011)"
    end
    it "last format should be (Smith, \"Test Resource\" 2011)" do
      formatter.format(resource).last.should == "(Smith, \"Test Resource\" 2011)"
    end
  end
end