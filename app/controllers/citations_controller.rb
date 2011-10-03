class CitationsController < ApplicationController
  def create
    @document = Document.find(params[:document_id])
    @resource = Resource.find(params[:resource_id])
    @citation = @resource.citations.create(params[:citation].merge(:default => @resource.citations.empty?))
    redirect_to view_pad_path(@document)
  end

  def destroy
    @document = Document.find(params[:document_id])
    @citation = Citation.find(params[:id])
    @citation.destroy
    redirect_to view_pad_path(@document)
  end
end
