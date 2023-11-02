module UpsertServices
  class ObjectImage
    include SquareClient

    def initialize(images:, item:)
      @images = images
      @item = item
    end

    def run!
      images.each do |image|
        handle_upsert_result_image(upsert_catalog_image(image))
      end
    end

    private

    attr_reader :images, :item

    # Upsert catalog image to Square API
    def upsert_catalog_image(image)
        file_to_upload_path = image.tempfile # Modify this to point to your desired file.
        file = File.open(file_to_upload_path, "rb")
        client.catalog.create_catalog_image(
          image_file: file,
          request: build_upsert_request(image)
        )
    end

    # Constructs the payload for the upsert catalog image API call
    def build_upsert_request(image)
      {
        idempotency_key: SecureRandom.uuid,
        object_id: item.square_id,
        image: {
          type: "IMAGE",
          id: "#image",
          image_data: {
            name: image.original_filename
          }
        }
      }
    end

    # Handles the result of the upsert catalog image API call
    def handle_upsert_result_image(result)
      if result.success?
        update_item_variation_image_url(result.data.first)
      elsif result.error?
        warn result.errors
      end
    end

    # Updates the item variation image URL if the upsert was successful
    def update_item_variation_image_url(data)
      new_image_url = data[:image_data][:url]
      item.image_urls << new_image_url
      item.save!
    end
  end
end
