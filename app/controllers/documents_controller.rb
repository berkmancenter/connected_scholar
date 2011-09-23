class DocumentsController < ApplicationController

  def index
    redirect_to root_url
  end

  # GET /documents/1
  # GET /documents/1.json
  def show
    @document = Document.find(params[:id])

    respond_to do |format|
      format.html # _resource.html.erb
      format.json { render json: @document }
    end
  end

  # GET /documents/new
  # GET /documents/new.json
  def new
    @document = Document.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @document }
    end
  end

  # GET /documents/1/edit
  def edit
    @document = Document.find(params[:id])
  end

  # POST /documents
  # POST /documents.json
  def create
    @document = Document.new(params[:document].merge(:owner => current_user))

    respond_to do |format|
      if @document.save
        format.html { redirect_to "/view_pad/#{@document.id}", notice: 'Document was successfully created.' }
        format.json { render json: @document, status: :created, location: @document }
      else
        format.html { render action: "new" }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /documents/1
  # PUT /documents/1.json
  def update
    @document = Document.find(params[:id])

    respond_to do |format|
      if @document.update_attributes(params[:document])
        format.html { redirect_to @document, notice: 'Document was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  def add_contributor
    email = params[:contributor_email]
    @document = Document.find(params[:id])
    @document.add_contributor_by_email(email) do |error|
      case error
        when :cannot_add_owner
          flash[:alert] = "Cannot add yourself as a contributor"
        when :unrecognized_email
          flash[:alert] = "Could not find user for: #{email}"
      end
    end
    redirect_to @document
  end

  def remove_contributor
    @document = Document.find(params[:id])
    @contributor = User.find(params[:contributor_id])
    @document.remove_contributor(@contributor)
    redirect_to @document
  end

  # DELETE /documents/1
  # DELETE /documents/1.json
  def destroy
    @document = Document.find(params[:id])
    @document.destroy

    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :ok }
    end
  end

  def active_citations
    @document = Document.find(params[:id])
    render :json => @document.active_citations
  end

  def citation
    @document = Document.find(params[:id])
    if @document.add_citation(params[:citation], params[:resource_id])
      render :text => ""
    else
      render :text => "Duplicate citation."
    end
  end
end
