class FragranceProfilePolicy < ApplicationPolicy
  include AdminBasePolicy

  def permitted_attributes
    %i[name_fr name_en]
  end
end
