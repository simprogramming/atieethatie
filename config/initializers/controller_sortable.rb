module ControllerSortable
  extend ActiveSupport::Concern

  class_methods do
    def add_sortering(name, options = {})
      before_action options do
        @_sort_variable_name = name
        @_record_to_apply_sort = "@#{name}"
      end
    end
  end

  def render(*args)
    if @_record_to_apply_sort.present?
      records = instance_variable_get(@_record_to_apply_sort)
      instance_variable_set(@_record_to_apply_sort, apply_sortering(records))
    end

    super(*args)
  end

  def apply_sortering(records)
    return records unless [params[:sort_by], params[:sort_direction], @_record_to_apply_sort].all?(&:present?)
    return records unless %w[asc desc].include? params[:sort_direction]

    if respond_to?(_override_sort_method_name, true)
      send(_override_sort_method_name, records, params[:sort_direction])
    else
      _apply_controller_sortable(records, params[:sort_by], params[:sort_direction])
    end
  end

  def _apply_controller_sortable(records, sort_by, sort_direction)
    if sort_by.include?(".") && !sort_by.start_with?("#{records.model.table_name}.")
      parts = sort_by.split(".")
      _join_association_with_alias(records, parts[0]).reorder("\"#{parts[0]}\".#{parts[1]} #{sort_direction}")
    else
      records.reorder(sort_by.underscore => sort_direction)
    end
  end

  def _join_association_with_alias(records, association)
    # Since Rails 6.1.1+, joined tables are aliased if includes is used with where(...)
    # Here is an hacky way to for aliasing (adding a where condition that does nothing)
    query = records.includes(association)
    query.where.not({ association => { id: nil } }).or(query.where({ association => { id: nil } }))
  end

  def _override_sort_method_name
    "sort_#{@_sort_variable_name}_by_#{params[:sort_by].underscore}"
  end
end

ActiveSupport.on_load(:action_controller) { prepend ControllerSortable }
