module SyncVersionServices
  class ObjectItem
    include SquareClient

    def initialize(item:)
      @item = item
    end

    def run!
      update_version(item)
    end

    private

    attr_accessor :item

    def update_version(item)
      result = client.catalog.retrieve_catalog_object(object_id: item.square_id)
      if result.success?
        item.version = result.data.first[:version]
        update_version_variations(item.catalog_item_variations)
        item.save!
      elsif result.error?
        warn result.errors
      end

    end

    def update_version_variations(variations)
      variations.each do |variation|
        result = client.catalog.retrieve_catalog_object(object_id: variation.square_id)
        if result.success?
          variation.version = result.data.first[:version]
          variation.save!
        elsif result.error?
          warn result.errors
        end
      end
    end
  end
end
