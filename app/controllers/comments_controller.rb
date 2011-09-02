class CommentsController < ApplicationController
  def create
    @document = Document.find(params[:document_id])
    @comment = @document.comments.create(params[:comment].merge(:author => current_user))
    redirect_to view_pad_path(@document)
  end
 
  def destroy
    @document = Document.find(params[:document_id])
    @comment = @document.comments.find(params[:id])
    @comment.destroy
    redirect_to view_pad_path(@document)
  end
end
