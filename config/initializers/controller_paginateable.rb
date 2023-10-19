module ControllerPaginateable
  extend ActiveSupport::Concern

  class_methods do
    def add_pagination(name, options = {})
      before_action options do
        @_record_to_apply_pagination = "@#{name}"
      end
    end
  end

  def render(*args)
    if @_record_to_apply_pagination.present?
      records = instance_variable_get(@_record_to_apply_pagination)
      instance_variable_set(@_record_to_apply_pagination, apply_pagination(records))
    end

    super(*args)
  end

  def apply_pagination(records)
    records.paginated(params)
  end
end

ActiveSupport.on_load(:action_controller) { prepend ControllerPaginateable }
