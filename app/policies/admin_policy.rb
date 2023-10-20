class AdminPolicy < ApplicationPolicy
  include AdminBasePolicy

  def admin?
    true
  end
end
