class FragrancePolicy < ApplicationPolicy
  include AdminBasePolicy

  def permitted_attributes
    %i[name_fr name_en fragrance_profile_id]
  end
end
