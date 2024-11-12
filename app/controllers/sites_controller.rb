class SitesController < ApplicationController
  include OrderHelper
  before_action -> { authorize :sites }
  before_action :set_product, only: :product

  add_controller_helpers :catalog_item_variations, helpers: %i[search sort], only: :products
  def home
    @catalog_item_variations = CatalogItemVariation.available.sample(5)
  end

  def about
  end

  def policy_return
  end

  def products
    products_in_store
  end

  def product

  end


  private

  def set_product
    @catalog_item_variation = CatalogItemVariation.find(params[:id])
    return if @catalog_item_variation&.available?

    redirect_to root_path, alert: "Cette variante de produit n'est pas disponible."
  end

  def products_in_store
    @catalog_item_variations = CatalogItemVariation.available
    if params[:category_ids].present?
      category_ids = params[:category_ids].split(",")
      @catalog_item_variations = @catalog_item_variations.joins(:catalog_item).where(catalog_items: { category_id: category_ids })
    end
    if params[:colors].present?
      colors = params[:colors].split(",")
      @catalog_item_variations = @catalog_item_variations.where(color: colors)
    end
    if params[:sizes].present?
      sizes = params[:sizes].split(",")
      @catalog_item_variations = @catalog_item_variations.where(size: sizes)
    end
    return if params[:fragrance_profile_ids].blank?

    fragrance_profile_ids = params[:fragrance_profile_ids].split(",")
    @catalog_item_variations = @catalog_item_variations.joins(catalog_item: :fragrance)
                                                       .where(fragrances: { fragrance_profile_id: fragrance_profile_ids }).distinct
    
  end
end
