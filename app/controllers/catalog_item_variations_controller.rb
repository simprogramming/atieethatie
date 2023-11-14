class CatalogItemVariationsController < ApplicationController
  include AdminSideHelper
  before_action :set_catalog_item
  before_action :sync_items, only: :edit
  before_action :set_catalog_item_variation, only: %i[edit update show destroy]
  before_action -> { authorize @catalog_item_variation || CatalogItemVariation }

  decorates_assigned :catalog_item_variation, :catalog_item_variations
  add_controller_helpers :catalog_item_variations, only: :index

  def index
    @catalog_item_variations = policy_scope(CatalogItemVariation).where(catalog_item_id: @catalog_item.id)
                                                                 .order(available: :desc)
  end

  def show
  end

  def new
    @catalog_item_variation = CatalogItemVariation.new
  end

  def edit
  end

  def create
    @catalog_item_variation = CatalogItemVariation.new(permitted_attributes(CatalogItemVariation).except("images"))
    @catalog_item_variation.sku = CatalogItemVariation.generate_sku
    @catalog_item_variation.catalog_item = @catalog_item
    if @catalog_item_variation.valid?
      UpsertServices::ObjectItemVariation.new(item_variation: @catalog_item_variation,
                                              images: params[:catalog_item_variation][:images].compact_blank).run!
      redirect_to [@catalog_item, @catalog_item_variation], notice: create_successful_notice
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @catalog_item_variation.update(permitted_attributes(catalog_item_variation).except("images"))
    if @catalog_item_variation.valid?
      UpsertServices::ObjectItemVariation.new(item_variation: @catalog_item_variation,
                                              images: params[:catalog_item_variation][:images].compact_blank).run!
      redirect_to [@catalog_item, @catalog_item_variation], notice: update_successful_notice
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @catalog_item_variation.image_ids.each do |image|
      DeleteServices::CatalogObject.new(image).run!
    end
    DeleteServices::CatalogObject.new(@catalog_item_variation.square_id).run!
    @catalog_item_variation.destroy
    redirect_to @catalog_item, notice: destroy_successful_notice
  end

  private

  def set_catalog_item
    @catalog_item = policy_scope(CatalogItem).find(params[:catalog_item_id])
  end

  def set_catalog_item_variation
    @catalog_item_variation = policy_scope(@catalog_item.catalog_item_variations).find(params[:id])
  end

  def sync_items
    SyncVersionServices::ObjectItem.new(item: @catalog_item).run!
  end
end
