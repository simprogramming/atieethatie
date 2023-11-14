class SitesPolicy < ApplicationPolicy
  def home?
    true
  end

  def products?
    true
  end

  def product?
    true
  end
end
