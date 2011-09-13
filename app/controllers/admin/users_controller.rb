class Admin::UsersController < ApplicationController
  load_and_authorize_resource

  # GET /users
  # GET /users.xml
  # GET /users.json                                       HTML and AJAX
  #-----------------------------------------------------------------------
  def index
    @users = User.all
    respond_to do |format|
      format.json { render :json => @users }
      format.xml  { render :xml => @users }
      format.html
    end
  end

  def approve
    @user = User.find(params[:user_id])
    authorize! :manage, @user
    @user.approve!
    @user.save!
    puts "its now ===========> #{@user.approved?.inspect}"
    respond_to do |format|
      format.json { render :json => @user }
      format.xml  { render :xml => @user }
      format.html { redirect_to admin_users_path }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  # GET /users/1.json                                     HTML AND AJAX
  #-------------------------------------------------------------------
  #def show
  #  respond_to do |format|
  #    format.json { render :json => @user }
  #    format.xml  { render :xml => @user }
  #    format.html
  #  end
  #
  #rescue ActiveRecord::RecordNotFound
  #  respond_to_not_found(:json, :xml, :html)
  #end
  #
  ## GET /users/1/edit
  ## GET /users/1/edit.xml
  ## GET /users/1/edit.json                                HTML AND AJAX
  ##-------------------------------------------------------------------
  #def edit
  #  respond_to do |format|
  #    format.json { render :json => @user }
  #    format.xml  { render :xml => @user }
  #    format.html
  #  end
  #
  #rescue ActiveRecord::RecordNotFound
  #  respond_to_not_found(:json, :xml, :html)
  #end

  # DELETE /users/1
  # DELETE /users/1.xml
  # DELETE /users/1.json                                  HTML AND AJAX
  #-------------------------------------------------------------------
  def destroy
    @user.destroy!

    respond_to do |format|
      format.json { respond_to_destroy(:ajax) }
      format.xml  { head :ok }
      format.html { redirect_to admin_users_path }
    end

  rescue ActiveRecord::RecordNotFound
    respond_to_not_found(:json, :xml, :html)
  end
  
end