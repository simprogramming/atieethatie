class CatalogItemsController < ApplicationController
  include AdminSideHelper
  before_action :set_catalog_item, only: %i[edit update show destroy]
  before_action :sync_items, only: %i[edit]
  before_action -> { authorize @catalog_item || CatalogItem }

  decorates_assigned :catalog_item, :catalog_items
  add_controller_helpers :catalog_items, only: :index

  def index
    @catalog_items = policy_scope(CatalogItem).order(:name_fr)
  end

  def show
  end

  def new
    @catalog_item = CatalogItem.new
    @catalog_item.catalog_item_variations.build
  end

  def edit
  end

  def create
    @catalog_item = CatalogItem.new(permitted_attributes(CatalogItem).except("images"))
    if @catalog_item.valid?
      @catalog_item.catalog_item_variations.each do |variation|
        variation.sku = CatalogItemVariation.generate_sku
      end
      UpsertServices::ObjectItem.new(item: @catalog_item, images: params[:catalog_item][:images].compact_blank).run!
      redirect_to catalog_items_path, notice: create_successful_notice
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @catalog_item.update(permitted_attributes(catalog_item))
    if @catalog_item.valid?
      UpsertServices::ObjectItem.new(item: @catalog_item, images: nil).run!
      @catalog_item.save
      redirect_to catalog_items_path, notice: update_successful_notice
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @catalog_item.catalog_item_variations.each do |variation|
      next if variation.image_ids.blank?

      variation.image_ids.each do |image|
        DeleteServices::CatalogObject.new(image).run!
      end
    end
    
    DeleteServices::CatalogObject.new(@catalog_item.square_id).run!
    @catalog_item.destroy
    redirect_to catalog_items_path, notice: destroy_successful_notice
  end

  def sync
    skip_policy_scope
    PullServices::ObjectItems.new.run!
    redirect_to catalog_items_path, notice: update_successful_notice
  end

  private

  def set_catalog_item
    @catalog_item = policy_scope(CatalogItem).find(params[:id])
  end

  def sync_items
    SyncVersionServices::ObjectItem.new(item: @catalog_item).run!
  end
end
