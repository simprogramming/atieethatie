class OrderPolicy < ApplicationPolicy
  include AdminBasePolicy


  def add_item?
    true
  end

  def remove_item?
    true
  end

  def cart_page?
    true
  end  

  def checkout?
    true
  end

  def process_square_payment?
    true
  end

  def receipt?
    true
  end

  def apply_promo_code?
    true
  end

  def shipped?
    user.admin?
  end

  def permitted_attributes
    %i[promo_code]
  end
end
