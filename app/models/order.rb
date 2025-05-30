class Order < ApplicationRecord
  has_one :shipping_address, -> { where(address_type: "shipping") }, class_name: "Address", dependent: :destroy
  has_one :billing_address, -> { where(address_type: "billing") }, class_name: "Address", dependent: :destroy

  has_many :order_items, dependent: :destroy
  has_many :catalog_item_variations, through: :order_items

  validates :session_id, presence: true

  enum shipping_status: { pending: "pending", processing: "processing", shipped: "shipped", completed: "completed" }
  translate_enum :shipping_status
  
  PROMO_CODE_FREE_SHIPPING = "SANSFRAIS"

  def apply_promo_code!(code)
    self.promo_code = code
    save
  end

  def free_shipping?
    promo_code == PROMO_CODE_FREE_SHIPPING
  end
end
