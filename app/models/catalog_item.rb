class CatalogItem < ApplicationRecord
  searchable :name_fr, :name_en

  localize_attribute :name, :description

  has_rich_text :description_fr
  has_rich_text :description_en

  belongs_to :category

  has_many :catalog_item_variations, dependent: :destroy
  accepts_nested_attributes_for :catalog_item_variations

  validates :name_fr, :name_en, presence: true
end
