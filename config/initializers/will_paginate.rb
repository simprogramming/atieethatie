require "will_paginate/array"

WillPaginate.per_page = 15

module SimplifiedPagination
  INVALID_VALUES = %w[undefined null].freeze

  def paginated(params)
    pagination_params = params.reject { |_, value| INVALID_VALUES.include?(value) }
    paginate(
      page: [(pagination_params[:page].presence || 1).to_i, 1].max,
      per_page: (pagination_params[:per_page].presence || WillPaginate.per_page).to_i.clamp(1, 200)
    )
  end
end

ActiveSupport.on_load(:active_record) { extend SimplifiedPagination }
Array.include SimplifiedPagination
