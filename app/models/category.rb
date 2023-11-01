class Category < ApplicationRecord
  searchable :name_fr, :name_en

  localize_attribute :name
  validates :name_fr, :name_en, presence: true

  has_many :catalog_items, dependent: :destroy
end
