module ControllerSearchable
  extend ActiveSupport::Concern

  class_methods do
    def add_search_filtering(name, options = {})
      before_action options do
        @_records_to_apply_search = "@#{name}"
      end
    end
  end

  def render(*args)
    if @_records_to_apply_search.present?
      records = instance_variable_get(@_records_to_apply_search)
      instance_variable_set(@_records_to_apply_search, apply_search_filtering(records))
    end

    super(*args)
  end

  def apply_search_filtering(records)
    return records if params[:search].blank?

    records.search(params[:search])
  end
end

ActiveSupport.on_load(:action_controller) { prepend ControllerSearchable }
