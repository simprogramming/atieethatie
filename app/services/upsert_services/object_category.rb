module UpsertServices
  class ObjectCategory
    include SquareClient

    def initialize(category:, params:)
      @category = category
      @params = params
    end

    def run!
      handle_upsert_result(upsert_catalog_object)
    end

    private

    attr_accessor :category, :params

    def upsert_catalog_object
      client.catalog.upsert_catalog_object(
        body: build_upsert_body
      )
    end

    def build_upsert_body
      {
        idempotency_key: SecureRandom.uuid,
        object: {
          type: "CATEGORY",
          id: category.square_id.presence || "#123",
          version: category.version.presence || nil,
          category_data: {
            name: params[:name_fr]
          }
        }
      }
    end

    def handle_upsert_result(result)
      if result.success?
        update_category(result.data.first) if category.version.blank?
        nil
      elsif result.error?
        warn result.errors
      end
    end

    def update_category(data)
      category.version = data[:version]
      category.square_id = data[:id]
      category.save!
    end
  end
end
