require 'spec_helper'

describe User do

  subject do
    User.create! :name => "Test User", :email => 'test@test.com', :password => 'password', :password_confirmation => 'password'
  end

  describe "#preferences" do
    it "should save preferences" do
      subject.preferences[:citation_format] = :mla
      subject.save!

      u = User.find(subject.id)
      u.preferences[:citation_format].should == :mla
    end
  end
end
