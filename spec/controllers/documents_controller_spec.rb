require 'spec_helper'

describe DocumentsController do
  include Devise::TestHelpers

  let :user do
    User.create! :name => "Test User", :email => 'test@test.com', :password => 'password', :password_confirmation => 'password'
  end

  let :contributor do
    User.create! :name => "Contrib User", :email => 'contrib@test.com', :password => 'password', :password_confirmation => 'password'
  end

  let :document do
    Document.create! :name => 'foobar', :owner => user
  end

  before (:each) do
    sign_in :user, user
  end

  describe "POST add_contributor" do
    describe "with valid params" do
      it "creates a new Resource" do
        pending
        expect {
          post :add_contributor, :contributor_email => contributor.email, :document_id => document.id
        }.to change(Resource, :count).by(1)
      end

      it "assigns a newly created resource as @resource" do
        pending
        post :add_contributor, :contributor_email => contributor.email, :document_id => document.id
        assigns(:resource).should be_a(Resource)
        assigns(:resource).should be_persisted
      end

      it "redirects to the created resource" do
        pending
        post :add_contributor, :contributor_email => contributor.email, :document_id => document.id
        response.should render_template("documents/show")
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved resource as @resource" do
        pending
        # Trigger the behavior that occurs when invalid params are submitted
        Resource.any_instance.stub(:save).and_return(false)
        post :create, :resource => {}, :document_id => document.id
        assigns(:resource).should be_a_new(Resource)
      end

      it "re-renders the '?' template" do
        pending
        Resource.any_instance.stub(:save).and_return(false)
        post :add_contributor, :contributor_email => 'foobar', :document_id => document.id
        response.should render_template("documents/show")
      end
    end
  end

  describe "DELETE remove_contributor" do
    it "removes the resource from the list" do
      pending
      resource = Resource.create! valid_attributes.merge(:document_id => document.id)
      expect {
        delete :destroy, :id => resource.id.to_s, :document_id => document.id
      }.to change(Resource, :count).by(-1)
    end

    it "redirects to the resources list" do
      pending
      resource = Resource.create! valid_attributes.merge(:document_id => document.id)
      delete :destroy, :id => resource.id.to_s, :document_id => document.id
      response.should redirect_to(document)
    end
  end

end
