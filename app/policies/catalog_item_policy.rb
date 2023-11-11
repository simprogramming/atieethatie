class CatalogItemPolicy < ApplicationPolicy
  include AdminBasePolicy

  def sync?
    user.admin?
  end

  def permitted_attributes
    [:name_fr, :name_en, :description_fr, :description_en, :square_id, :version, :category_id, :fragrance_id,
     { catalog_item_variations_attributes: %i[name_fr name_en price color size information_fr information_en
                                              instruction_fr instruction_en], images: [] }]
  end
end
