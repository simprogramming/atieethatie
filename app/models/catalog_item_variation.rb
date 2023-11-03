class CatalogItemVariation < ApplicationRecord
  searchable :name_fr, :name_en

  localize_attribute :name, :description

  has_rich_text :information_fr
  has_rich_text :information_en

  belongs_to :catalog_item

  before_create :generate_sku

  validates :name_fr, :name_en, :price, presence: true

  private

  def self.generate_sku
    loop do
      uuid_prefix = SecureRandom.uuid[0..2].upcase
      timestamp = Time.now.to_i.to_s
      sku = "#{uuid_prefix}-#{timestamp}"
      break sku unless exists?(sku: sku)
    end
  end

end
