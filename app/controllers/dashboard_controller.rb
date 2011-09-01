class DashboardController < ApplicationController

  def index
    @my_documents = Document.find_my_documents(current_user)
    @shared_documents = Document.find_shared_documents(current_user)
  end

end
