class SitesController < ApplicationController
  before_action -> { authorize :sites }
  def home
  end

  def products

  end

  def product

  end
end
