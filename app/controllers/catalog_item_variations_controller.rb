class CatalogItemVariationsController < ApplicationController
  include AdminSideHelper
  before_action :set_catalog_item_variation, only: %i[edit update show destroy]
  before_action -> { authorize @catalog_item_variation || CatalogItemVariation }

  decorates_assigned :catalog_item_variation, :catalog_item_variations
  add_controller_helpers :catalog_item_variations, only: :index

  def index
    @catalog_item_variations = policy_scope(CatalogItemVariation).order(:name_fr)
  end


  def show
  end

  def new
    @catalog_item_variation = CatalogItemVariation.new
  end

  def edit
  end

  def create
    @catalog_item_variation = CatalogItemVariation.new(permitted_attributes(CatalogItemVariation))

    if @catalog_item_variation.save
      # UpsertServices::ObjectItemVariation.new(item: @catalog_item_variation, params: permitted_attributes(CatalogItem)).run!
      redirect_to @catalog_item_variation, notice: create_successful_notice
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @catalog_item_variation.update(permitted_attributes(catalog_item_variation))
    if @catalog_item_variation.save
      # UpsertServices::CatalogItemVariation.new(catalog_item_variation: @catalog_item_variation, params: permitted_attributes(catalog_item_variation)).run!
      redirect_to catalog_item_variations_path, notice: update_successful_notice
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    # DeleteServices::CatalogItemVariation.new(@catalog_item_variation.square_id).run!
    @catalog_item_variation.destroy
    redirect_to catalog_item_variations_path, notice: destroy_successful_notice
  end

  # def sync
  #   skip_policy_scope
  #   PullServices::ObjectItemVariations.new.run!
  #   redirect_to catalog_item_variations_path, notice: update_successful_notice
  # end

  private

  def set_catalog_item_variation
    @catalog_item_variation = policy_scope(CatalogItemVariation).find(params[:id])
  end
end
