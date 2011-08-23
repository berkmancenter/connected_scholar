class ResourcesController < ApplicationController
  def create
    @document = Document.find(params[:document_id])
    @resource = @document.recommended_resources.create(params[:resource])
    redirect_to @document
  end

  def destroy
    @document = Document.find(params[:document_id])
    @resource = @document.recommended_resources.find(params[:id])
    @resource.destroy
    redirect_to @document
  end
end
