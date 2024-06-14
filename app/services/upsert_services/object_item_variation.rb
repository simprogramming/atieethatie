module UpsertServices
  # This class handles upserting items and their associated images into the Square catalog.
  class ObjectItemVariation
    include SquareClient

    def initialize(item_variation:, images: nil)
      @item_variation = item_variation
      @images = images
    end

    # Main method to run the upsert process.
    def run!
      handle_upsert_result(upsert_catalog_object)
    end

    private

    attr_accessor :item_variation, :images

    # Calls the Square API to upsert the catalog object.
    def upsert_catalog_object
      client.catalog.upsert_catalog_object(body: build_upsert_body)
    end

    # Constructs the payload required for upserting the catalog object.
    def build_upsert_body
      {
        idempotency_key: SecureRandom.uuid,
        object: {
          type: "ITEM_VARIATION",
          id: item_variation.square_id.presence || "#item",
          version: item_variation.version.presence || nil,
          item_variation_data: build_item_variation_data
        }
      }
    end

    # Builds the data for an item variation.
    def build_item_variation_data
      {
        image_ids: item_variation.images.pluck(:square_id).presence || nil,
        sku: item_variation.sku,
        item_id: item_variation.catalog_item.square_id,
        name: item_variation.name_fr,
        pricing_type: "FIXED_PRICING",
        price_money: {
          amount: (item_variation.price.to_f * 100).to_i,
          currency: "CAD"
        }
      }
    end

    # Processes the result from the Square API upsert call.
    def handle_upsert_result(result)
      if result.success?
        assign_id_version_item_variation(result.data.first)
      elsif result.error?
        warn result.errors
      end
    end

    # Updates the item and its variations if the upsert was successful.
    def assign_id_version_item_variation(data)
      item_variation.assign_attributes(
        square_id: data[:id],
        version: data[:version]
      )
      item_variation.save!
      SyncVersionServices::ObjectItem.new(item: item_variation.catalog_item).run! if images.blank?
      return unless images.present? && item_variation.square_id.present? && item_variation.version.present?

      UpsertServices::ObjectImage.new(item: item_variation, images: images).run!
    end
  end
end
