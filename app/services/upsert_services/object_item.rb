module UpsertServices
  # This class handles upserting items and their associated images into the Square catalog.
  class ObjectItem
    include SquareClient

    def initialize(item:, images: nil)
      @item = item
      @images = images
    end

    # Main method to run the upsert process.
    def run!
      handle_upsert_result(upsert_catalog_object)
    end

    private

    attr_accessor :item, :images

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
          id: item.square_id.presence || "#item",
          version: item.version.presence || nil,
          item_data: build_item_data
        }
      }
    end

    # Builds the item data portion of the payload.
    def build_item_data
      {
        name: item.name_fr,
        category_id: Category.find(item.category_id).square_id,
        description: item.description_fr.to_plain_text,
        product_type: "REGULAR",
        variations: insert_variations
      }
    end

    # Constructs the variations for the item.
    def insert_variations
      item.catalog_item_variations.map do |variation|
        {
          type: "ITEM_VARIATION",
          id: variation.square_id.presence || "#item_variation",
          version: variation.version.presence || nil,
          item_variation_data: build_item_variation_data(variation)
        }
      end
    end

    # Builds the data for an item variation.
    def build_item_variation_data(variation)
      {
        sku: variation.sku,
        item_id: item.square_id.presence || "#item",
        name: variation.name_fr,
        pricing_type: "FIXED_PRICING",
        price_money: {
          amount: (variation.price.to_i * 100),
          currency: "CAD"
        },
        image_ids: variation.images.pluck(:square_id).presence || nil
      }
    end

    # Processes the result from the Square API upsert call.
    def handle_upsert_result(result)
      if result.success?
        assign_id_version_item(result.data.first)
      elsif result.error?
        warn result.errors
      end
    end

    # Updates the item and its variations if the upsert was successful.
    def assign_id_version_item(data)
      item.assign_attributes(square_id: data[:id], version: data[:version])

      ActiveRecord::Base.transaction do
        item.save!
        assign_id_version_to(data[:item_data][:variations])
      end
    end

    # Updates each variation of the item.
    def assign_id_version_to(variations)
      ActiveRecord::Base.transaction do
        variations.each do |variation_data|
          item_variation = item.catalog_item_variations.detect do |iv|
            iv.sku == variation_data[:item_variation_data][:sku]
          end

          next unless item_variation

          item_variation.assign_attributes(
            square_id: variation_data[:id],
            version: variation_data[:version]
          )

          # Sauvegarde de item_variation pour obtenir un ID
          item_variation.save!
          if images.present?
            # Exécution du service ObjectImage seulement si item_variation est sauvegardé
            UpsertServices::ObjectImage.new(item: item_variation, images: images).run!
          end
        end
      end
    end
  end
end
