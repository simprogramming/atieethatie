module PaginationHelper
  def add_pagination(records, model_name: nil)
    return nil unless records.respond_to? :current_page

    tag.div class: "d-flex flex-wrap justify-content-between align-items-center" do
      [
        tag.div(class: "") { will_paginate records, renderer: WillPaginate::ActionView::BootstrapLinkRenderer },
        tag.div(class: "text-nowrap") { page_entries_info(records, model: model_name) }
      ].join.html_safe
    end
  end
end
