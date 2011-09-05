class ResourcesController < ApplicationController
  include SearchUtil

  def create
    @document = Document.find(params[:document_id])
    item_id = params["item_id"]
    if item_id.nil?
      @resource = @document.recommended_resources.create(params[:resource])
      redirect_to @document
    else

      items = item_search(:id, item_id)
      item = items['docs'] ? items['docs'][0] : nil

      raise "No Item: #{item_id.inspect}" if item.nil? or item['id'] != item_id

      @resource = @document.recommended_resources.create(
          :title => item['title'],
          :authors => (item['creator'] || []).join(", "),
          :abstract => (item['desc_subject'] || []).join(", "),
          :source => item['publisher']
      )

      respond_to do |format|
        format.js {render :json => @resource}
      end
    end
  end

  def destroy
    @document = Document.find(params[:document_id])
    @resource = @document.recommended_resources.find(params[:id])
    @resource.destroy
    redirect_to @document
  end
end
