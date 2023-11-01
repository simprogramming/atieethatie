class CatalogItem < ApplicationRecord
  searchable :name_fr, :name_en

  localize_attribute :name, :description

  has_rich_text :description_fr
  has_rich_text :description_en

  belongs_to :category

  validates :name_fr, :name_en, presence: true
end
