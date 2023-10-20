class UserPolicy < ApplicationPolicy
  include AdminBasePolicy

  def permitted_attributes
    %i[first_name last_name role email password password_confirmation]
  end
end
