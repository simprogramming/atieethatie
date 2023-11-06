class Fragrance < ApplicationRecord
  searchable :name_fr, :name_en

  localize_attribute :name
  belongs_to :fragrance_profile

  has_many :catalog_items, dependent: :destroy

  validates :name_fr, :name_en, presence: true
end
