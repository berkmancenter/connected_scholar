class Admin::UsersController < ApplicationController
  load_and_authorize_resource

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
    respond_to do |format|
      format.json { render :json => @user }
      format.xml  { render :xml => @user }
      format.html { redirect_to admin_users_path }
    end
  end

  def promote
    @user = User.find(params[:user_id])
    authorize! :manage, @user
    @user.promote!
    @user.save!
    respond_to do |format|
      format.json { render :json => @user }
      format.xml  { render :xml => @user }
      format.html { redirect_to admin_users_path }
    end
  end

  def demote
    if params[:user_id] != current_user.id
      @user = User.find(params[:user_id])
      authorize! :manage, @user
      @user.demote!
      @user.save!
      respond_to do |format|
        format.json { render :json => @user }
        format.xml  { render :xml => @user }
        format.html { redirect_to admin_users_path }
      end
    else
      flash[:alert] = "You cannot remove the Admin role from yourself"
      redirect_to admin_users_path
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
    if @user != current_user
      @user.destroy!

      respond_to do |format|
        format.json { respond_to_destroy(:ajax) }
        format.xml  { head :ok }
        format.html { redirect_to admin_users_path }
      end
    else
      flash[:alert] = "You cannot delete yourself"
      redirect_to admin_users_path
    end

  rescue ActiveRecord::RecordNotFound
    respond_to_not_found(:json, :xml, :html)
  end
  
end