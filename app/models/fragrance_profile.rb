class FragranceProfile < ApplicationRecord
  searchable :name_fr, :name_en

  localize_attribute :name

  has_many :fragrances, dependent: :destroy
  has_many :catalog_items, through: :fragrances

  validates :name_fr, :name_en, presence: true
end
