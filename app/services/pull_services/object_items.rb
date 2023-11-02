module PullServices
  class ObjectItems
    include SquareClient

    def run!
      process_catalog_items
    end

    private

    def process_catalog_items
      return if fetched_catalog_items.blank?

      fetched_catalog_items.each do |square_catalog_item|
        update_or_create_catalog_item(square_catalog_item)
      end
    end

    def fetched_catalog_items
      result.success? ? result.data["objects"] : handle_error
    end

    def result
      @result ||= client.catalog.list_catalog(
        types: "ITEM"
      )
    end

    def update_or_create_catalog_item(square_catalog_item)
      catalog_item = CatalogItem.find_or_initialize_by(square_id: square_catalog_item[:id])
      catalog_item.assign_attributes(
        square_id: catalog_item.square_id.presence || square_catalog_item[:id],
        name_fr: catalog_item.name_fr.presence || square_catalog_item[:item_data][:name],
        name_en: square_catalog_item[:item_data][:name],
        version: square_catalog_item[:version],
        description_fr: catalog_item.description_fr.presence || square_catalog_item[:item_data][:description],
        description_en: square_catalog_item[:item_data][:description],
        category: Category.find_by(square_id: square_catalog_item[:item_data][:category_id]),
        image_urls: [image_url(square_catalog_item[:item_data][:image_ids]&.first)]
      )
      catalog_item.save!
    end

    def handle_error
      warn result.errors if result.error?
      nil
    end

    def image_url(id)
      return nil if id.blank?

      image = client.catalog.retrieve_catalog_object(
        object_id: id
      )
      image.data["object"][:image_data][:url] if image.present?
    end
  end
end
