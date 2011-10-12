class ResourcesController < ApplicationController
  include SearchUtil
  
  def show
    @document = Document.find(params[:document_id])
    @resource = @document.resources.find(params[:id])
    render :partial => 'resources/resource', :locals => {:resource => @resource, :make_draggable => false}
  end
  
  def create
    @document = Document.find(params[:document_id])
    item_id = params["item_id"]
    if item_id.nil?
      if params[:resource]
        params[:resource][:creators] = params[:resource][:creators].split("\n") if params[:resource][:creators]
        params[:resource][:id_isbn] = params[:resource][:id_isbn].split("\n") if params[:resource][:id_isbn]
        params[:resource][:desc_subject] = params[:resource][:desc_subject].split("\n") if params[:resource][:desc_subject]

        @resource = @document.resources.create(params[:resource])
      elsif params[:item]
        @resource = @document.resources.create(item_to_resource(params[:item]))
      end
      redirect_to view_pad_path(@document)
    else

      items = item_search(:id, item_id)
      item = items['docs'] ? items['docs'][0] : nil

      raise "No Item: #{item_id.inspect}" if item.nil? or item['id'] != item_id

      @resource = @document.resources.create(item_to_resource(item))

      respond_to do |format|
        format.js {render :json => @resource}
      end
    end
  end

  def destroy
    @document = Document.find(params[:document_id])
    @resource = @document.resources.find(params[:id])
    @resource.destroy
    redirect_to view_pad_path(@document)
  end
  
  def citation
    @document = Document.find(params[:document_id])
    @resource = @document.resources.find(params[:id])
    render :json => {'citation' => @resource.default_citation!}
  end
  
  def activate
    @document = Document.find(params[:document_id])
    @resource = @document.resources.find(params[:id])
    if @resource.active?
      render :text => ''
    else
      @resource.activate!
      render :partial => 'item', :locals => {:item => @resource, :make_draggable => true, :class_name => 'active_source'}
    end
  end

  def promote_citation
    @document = Document.find(params[:document_id])
    @citation = Citation.find(params[:citation_id])
    @citation.make_default!
    redirect_to view_pad_path(@document)
  end
  
  private

  def item_to_resource(item)
    resource = {}

    resource[:creators] = misc_to_array(item['creator'])
    resource[:desc_subject] = misc_to_array(item['desc_subject'])
    resource[:id_isbn] = misc_to_array(item['id_isbn'])
    resource[:publication_date] = item['pub_date'] ? Date.new(item['pub_date'].to_i, 1, 1) : nil

    resource[:title] = item['title']
    resource[:publisher] = item['publisher']
    resource[:pub_location] = item['pub_location']
    resource[:num_page] = item['num_page']
    resource[:id_lccn] = item['id_lccn']
    resource[:sub_title] = item['sub_title']
    resource[:id_librarycloud] = item['id_librarycloud']
    resource[:height] = item['height']
    resource[:material_format] = item['material_format']
    resource[:id_oclc] = item['id_oclc']
    resource[:id_lc_call_num] = item['id_lc_call_num']
    resource[:id_hollis] = item['id_inst']
    resource[:language] = item['language']

    resource
  end

  def misc_to_array(misc)
    if misc
      (misc.is_a?(Array) ? misc : [misc])
    else
      []
    end
  end
end
