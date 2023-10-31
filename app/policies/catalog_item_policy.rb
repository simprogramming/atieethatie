class CatalogItemPolicy < ApplicationPolicy
  include AdminBasePolicy

  def sync?
    user.admin?
  end

  def permitted_attributes
    %i[name_fr name_en description_fr description_en square_id version category_id]
  end
end
