module UpsertServices
  # This class handles upserting items and their associated images into the Square catalog.
  class ObjectItem
    include SquareClient

    def initialize(item:)
      @item = item
    end

    # Main method to run the upsert process.
    def run!
      handle_upsert_result(upsert_catalog_object)
    end

    private

    attr_reader :item

    # Calls the Square API to upsert the catalog object.
    def upsert_catalog_object
      client.catalog.upsert_catalog_object(body: build_upsert_body)
    end

    # Constructs the payload required for upserting the catalog object.
    def build_upsert_body
      {
        idempotency_key: SecureRandom.uuid,
        object: {
          type: "ITEM",
          id: item_id_or_placeholder,
          version: item.version.presence || nil,
          item_data: build_item_data
        }
      }
    end

    # Retrieves the Square ID of the item or returns a placeholder.
    def item_id_or_placeholder
      item.square_id.presence || "#item"
    end

    # Builds the item data portion of the payload.
    def build_item_data
      {
        name: item.name_en,
        category_id: Category.find(item.category_id).square_id,
        variations: insert_variations,
        description: item.description_en.to_plain_text,
        product_type: "REGULAR"
      }
    end

    # Constructs the variations for the item.
    def insert_variations
      item.catalog_item_variations.map do |variation|
        {
          type: "ITEM_VARIATION",
          id: variation_id_or_placeholder(variation),
          version: variation.version.presence || nil,
          item_variation_data: build_item_variation_data(variation)
        }
      end
    end

    # Retrieves the Square ID of the variation or returns a placeholder.
    def variation_id_or_placeholder(variation)
      variation.square_id.presence || "#item_variation"
    end

    # Builds the data for an item variation.
    def build_item_variation_data(variation)
      {
        sku: variation.sku,
        item_id: item_id_or_placeholder,
        name: variation.name_en,
        pricing_type: "FIXED_PRICING",
        price_money: {
          amount: (variation.price.to_i * 100),
          currency: "CAD"
        }
      }
    end

    # Processes the result from the Square API upsert call.
    def handle_upsert_result(result)
      if result.success?
        update_item(result.data.first)
      elsif result.error?
        warn result.errors
      end
    end

    # Updates the item and its variations if the upsert was successful.
    def update_item(data)
      item.update!(version: data[:version], square_id: data[:id])
      update_variations(data[:item_data][:variations])
    end

    # Updates each variation in the catalog.
    def update_variations(variations)
      variations.each do |variation|
        item_variation = item.catalog_item_variations.find_by(sku: variation[:item_variation_data][:sku])

        item_variation.update!(square_id: variation[:id], version: variation[:version])
      end
    end
  end
end
