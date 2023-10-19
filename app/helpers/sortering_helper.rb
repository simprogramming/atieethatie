module SorteringHelper
  def sortable_header(param_name, text)
    link_to url_for(_sorting_params(param_name)) do
      [
        text,
        _sort_icon(param_name.to_s == _sort_column.to_s, _sort_direction)
      ].join.html_safe
    end
  end

  private

  def _sort_column
    params[:sort_by].presence
  end

  def _sort_direction
    %w[asc desc].include?(params[:sort_direction]) ? params[:sort_direction] : nil
  end

  # :nocov:
  def _sort_icon(column_sorted, direction)
    base_icon = "ms-1 fa-solid fa-sort"

    return tag.i(class: base_icon) unless column_sorted

    tag.i(class: "#{base_icon}#{direction == 'asc' ? '-up' : '-down'}")
  end

  def _next_sorting
    return "asc" if _sort_direction.nil?
    return "desc" if _sort_direction == "asc"

    nil
  end
  # :nocov:

  def _sorting_params(param_name)
    request.query_parameters.except(:page)
           .merge(sort_by: param_name, sort_direction: _next_sorting)
           .except(*(_next_sorting.nil? ? %i[sort_by sort_direction] : []))
  end
end
