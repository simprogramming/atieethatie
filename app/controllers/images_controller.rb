class ImagesController < ApplicationController
  include AdminSideHelper
  before_action :set_image
  before_action -> { authorize @image || Image }


  def destroy
    DeleteServices::CatalogObject.new(@image.square_id).run!

    if @image.imageable.instance_of?(CatalogItemVariation)
      SyncVersionServices::ObjectItem.new(item: @image.imageable.catalog_item).run!
    elsif @image.imageable.instance_of?(CatalogItem)
      SyncVersionServices::ObjectItem.new(item: @image.imageable).run!
    end

    @image.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back(fallback_location: [@catalog_item, @catalog_item_variation]) }
    end
  end

  private

  def set_image
    @image = policy_scope(Image).find(params[:id])
  end
end
