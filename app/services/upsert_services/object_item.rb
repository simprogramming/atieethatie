module UpsertServices
  class ObjectItem
    include SquareClient

    def initialize(item:, params:)
      @item = item
      @params = params
    end

    def run!
      handle_upsert_result(upsert_catalog_object)
    end

    private

    attr_reader :item, :params

    def upsert_catalog_object
      client.catalog.upsert_catalog_object(
        body: build_upsert_body
      )
    end

    def build_upsert_body
      {
        idempotency_key: SecureRandom.uuid,
        object: {
          type: "ITEM",
          id: item.square_id.presence || "#123",
          version: item.version.presence || nil,
          item_data: {
            name: params[:name_en],
            description: params[:description_en],
            category: Category.find(params[:category_id]).square_id
          }
        }
      }
    end

    def handle_upsert_result(result)
      if result.success?
        update_item(result.data.first) if item.version.blank?
        nil
      elsif result.error?
        warn result.errors
      end
    end

    def update_item(data)
      item.version = data[:version]
      item.square_id = data[:id]
      item.save!
    end
  end
end
