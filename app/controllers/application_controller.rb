class ApplicationController < ActionController::Base
  include Pundit::Authorization
  include NoticeHelper
  include LocaleHelper

  layout :resolve_layout

  def resolve_layout
    "application"
  end
end
