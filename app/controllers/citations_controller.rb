class CitationsController < ApplicationController
  def create
    @document = Document.find(params[:document_id])
    @resource = Resource.find(params[:resource_id])

    respond_to do |format|
      if @resource.citations.create(params[:citation].merge(:default => @resource.citations.empty?)).save
        format.html do
          redirect_to view_pad_path(@document)
        end
        format.json do
          render :json => {}
        end
      else
        format.html do
          flash[:alert] = "Duplicate citation!"
          redirect_to view_pad_path(@document)
        end
        format.json do
          render :json => {:error => "Duplicate citation."}
        end
      end
    end
  end

  def destroy
    @document = Document.find(params[:document_id])
    @citation = Citation.find(params[:id])
    @citation.destroy
    redirect_to view_pad_path(@document)
  end
end
