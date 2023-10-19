class ApplicationController < ActionController::Base
  include Pundit::Authorization
  include NoticeHelper
  include LocaleHelper
end
