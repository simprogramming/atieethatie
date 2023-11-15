class OrderPolicy < ApplicationPolicy
  include AdminBasePolicy


  def add_item?
    true
  end

  def permitted_attributes
    %i[]
  end
end
