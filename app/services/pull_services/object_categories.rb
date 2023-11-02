module PullServices
  class ObjectCategories
    include SquareClient

    def run!
      process_categories
    end

    private

    def process_categories
      return if fetched_categories.blank?

      fetched_categories.each do |square_category|
        update_or_create_category(square_category)
      end
    end

    def fetched_categories
      result.success? ? result.data["objects"] : handle_error
    end

    def result
      @result ||= client.catalog.list_catalog(
        types: "CATEGORY"
      )
    end

    def update_or_create_category(square_category)
      category = Category.find_or_initialize_by(square_id: square_category[:id])
      category.assign_attributes(
        square_id: category.square_id.presence || square_category[:id],
        name_fr: category.name_fr.presence || square_category[:category_data][:name],
        name_en: square_category[:category_data][:name],
        version: square_category[:version]
      )
      category.save!
    end

    def handle_error
      warn result.errors if result.error?
      nil
    end
  end
end
