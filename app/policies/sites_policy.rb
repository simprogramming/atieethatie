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

  def about?
    true
  end

  def policy_return?
    true
  end
end
