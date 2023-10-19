class AdminPolicy < ApplicationPolicy
  include AdminBasePolicy

  def dashboard?
    true
  end
end
