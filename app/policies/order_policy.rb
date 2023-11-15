class OrderPolicy < ApplicationPolicy
  include AdminBasePolicy

  def permitted_attributes
    %i[]
  end
end
