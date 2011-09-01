require 'spec_helper'

describe "documents/show.html.erb" do
  before(:each) do
    @document = assign(:document, stub_model(Document, :name => 'pad name',
                                             :group => stub_model(Group),
                                             :owner => stub_model(User, :name => 'Joe')))
  end

  it "renders attributes in <p>" do
    render
  end
end
