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

  def permitted_attributes
    %i[]
  end
end
