module ControllerHelpers
  extend ActiveSupport::Concern

  class_methods do
    def add_controller_helpers(name, options = {})
      helpers = [options.delete(:helpers)].flatten.compact.presence || %i[pagination search sort]

      add_sortering name, options if helpers.include? :sort
      add_search_filtering name, options if helpers.include? :search
      add_pagination name, options if helpers.include? :pagination
    end
  end

  def apply_controller_helpers(record, options = {})
    helpers = [options.delete(:helpers)].flatten.compact.presence || %i[pagination search sort]

    record = apply_sortering record if helpers.include? :sort
    record = apply_search_filtering record if helpers.include? :search
    record = apply_pagination record if helpers.include? :pagination
    record
  end
end

ActiveSupport.on_load(:action_controller) { prepend ControllerHelpers }
