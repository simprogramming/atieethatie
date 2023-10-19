class AdminController < ApplicationController
  include AdminSideHelper

  before_action -> { authorize :admin }
  def dashboard
  end
end
