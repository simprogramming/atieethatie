class Address < ApplicationRecord
  belongs_to :order

  validates :first_name, :last_name, :address_line, :address_type, :city, :province, :country, :postal_code, presence: true

  def formatted_address
    [
      "#{first_name} #{last_name}",
      [address_line, company].reject(&:blank?).join(", "),
      apartment,
      [city, province, postal_code].join(", "),
      country
    ].reject(&:blank?).join(", ")
  end
end
