module DeleteServices
  class CatalogObject
    include SquareClient

    def initialize(id)
      @id = id
    end

    def run!
      result = client.catalog.delete_catalog_object(
        object_id: id
      )

      if result.success?
        nil
      elsif result.error?
        warn result.errors
      end
    end

    private

    attr_reader :id
  end
end
