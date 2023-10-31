class CategoryPolicy < ApplicationPolicy
  include AdminBasePolicy

  def sync?
    user.admin?
  end

  def permitted_attributes
    %i[name_fr name_en square_id version]
  end
end
