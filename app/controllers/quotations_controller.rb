class QuotationsController < ApplicationController
  
  def show
    @document = Document.find(params[:document_id])
    @resource = Resource.find(params[:resource_id])
    @quotation = Quotation.find(params[:id])
    
    render :json => { :quote => @quotation.quote, :citation => @resource.default_citation! }
  end
  
  def create
    @document = Document.find(params[:document_id])
    @resource = Resource.find(params[:resource_id])
    
    if @resource.quotations.create(params[:quotation]).save
      flash[:notice] = "Quotation saved."
      redirect_to view_pad_path(@document)
    else
      flash[:alert] = "Error saving quotation."
      redirect_to view_pad_path(@document)
    end
  end
  
  def destroy
    @document = Document.find(params[:document_id])
    @quotation = Quotation.find(params[:id])
    @quotation.destroy
    redirect_to view_pad_path(@document)
  end
end