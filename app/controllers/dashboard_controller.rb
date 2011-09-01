class DashboardController < ApplicationController

  def index
    @my_documents = Document.where(:owner_id => current_user.id)
    @shared_documents = []
  end

end
