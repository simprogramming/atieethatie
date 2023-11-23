class Order < ApplicationRecord
  has_one :shipping_address, -> { where(address_type: "shipping") }, class_name: "Address", dependent: :destroy
  has_one :billing_address, -> { where(address_type: "billing") }, class_name: "Address", dependent: :destroy
  has_many :order_items, dependent: :destroy
  has_many :catalog_item_variations, through: :order_items

  validates :session_id, presence: true
end
