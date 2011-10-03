require 'spec_helper'

describe CitationsController do
  include Devise::TestHelpers

  let :user do
    u = User.create! :name => "Test User", :email => 'test@test.com', :password => 'password', :password_confirmation => 'password'
    u.approve!
    u.save!
    u
  end

  let :document do
    Document.create! :name => 'foobar', :owner => user
  end

  before (:each) do
    sign_in :user, user
  end

  describe "POST create" do
    let :resource do
      Resource.create! :document_id => document.id, :active => true, :publication_date => Date.today
    end

    context "format JSON" do
      it "should add the citation" do
        post "create", :format => :json, :document_id => document.id, :resource_id => resource.id, :citation => {:citation_text => "(Foo 2011)"}
        response.body.should == "{}"
      end
    end

    context "format HTML" do
      it "should add the citation" do
        post "create", :document_id => document.id, :resource_id => resource.id, :citation => {:citation_text => "(Foo 2011)"}
        response.should redirect_to(view_pad_path(document))
      end
    end

    context "when citation exists" do
      before do
        resource.default_citation!
        resource.save!
      end
      context "format JSON" do
        it "should not add the citation" do
          resource.citations.size.should == 1
          post "create", :format => :json, :document_id => document.id, :resource_id => resource.id, :citation => {:citation_text => resource.default_citation!}
          response.body.should_not == "{}"
        end
      end

      context "format HTML" do
        it "should add the citation" do
          post "create", :document_id => document.id, :resource_id => resource.id, :citation => {:citation_text => resource.default_citation!}
          response.should redirect_to(view_pad_path(document))
        end
      end
    end
  end
end