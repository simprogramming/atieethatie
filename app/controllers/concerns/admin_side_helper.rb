module AdminSideHelper
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
    after_action :verify_authorized, unless: :devise_controller?
    after_action :verify_policy_scoped, except: %i[new create] # rubocop:disable Rails/LexicallyScopedActionFilter
  end

  def resolve_layout
    "admin"
  end
end
