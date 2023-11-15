class Order < ApplicationRecord
  has_many :order_items, dependent: :destroy
  has_many :catalog_item_variations, through: :order_items

  validates :session_id, presence: true
end
