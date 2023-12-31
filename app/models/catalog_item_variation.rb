class CatalogItemVariation < ApplicationRecord
  searchable :name_fr, :name_en

  localize_attribute :name, :instruction, :information

  has_rich_text :information_fr
  has_rich_text :information_en
  has_rich_text :instruction_fr
  has_rich_text :instruction_en

  enum color: { white: "white", black: "black", gray: "gray", transparent: "transparent" }
  translate_enum :color

  belongs_to :catalog_item

  has_one :category, through: :catalog_item
  has_many :images, as: :imageable, dependent: :destroy

  validates :name_fr, :name_en, :price, :color, :size, presence: true

  validates :price, numericality: { greater_than_or_equal_to: 0, message: "must be a positive number" }

  scope :with_image, -> { where.not(image_urls: nil) }
  scope :available, -> { where(available: true)}

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
