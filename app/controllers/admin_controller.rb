class AdminController < ApplicationController
  include AdminSideHelper

  before_action -> { authorize :admin }
  def admin
    skip_policy_scope
  end
end
