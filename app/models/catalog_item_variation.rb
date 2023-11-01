class CatalogItemVariation < ApplicationRecord
  searchable :name_fr, :name_en

  localize_attribute :name, :description

  has_rich_text :description_fr
  has_rich_text :description_en

  belongs_to :catalog_item

  validates :name_fr, :name_en, :price, presence: true
end
