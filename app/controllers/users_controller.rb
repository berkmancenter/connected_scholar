class UsersController < ApplicationController

  def save_preferences
    current_user.preferences[:citation_format] = params[:citation_format]
    current_user.save
    redirect_to user_preferences_path
  end
end