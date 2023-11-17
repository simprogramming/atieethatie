class OrderItem < ApplicationRecord
  belongs_to :catalog_item_variation
  belongs_to :order

  has_one :catalog_item, through: :catalog_item_variation

  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 0, only_integer: true }
end
