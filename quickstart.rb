require 'square'

client = Square::Client.new(
  access_token: ENV.fetch('SQUARE_ACCESS_TOKEN'),
  environment: 'sandbox',
  timeout: 1
)

catalog_api = client.catalog

# Prepare the parameters for the API call


# Make the API call to list all items
result = catalog_api.list_catalog(
  types: "CATEGORY"
)

category_id = result.data["objects"].first[:id] # Replace with the actual category ID
category_data = {
  name: 'New Category Name'
}
version = 1697826036326
puts category_id
result2 = client.catalog.upsert_catalog_object(
  body: {
    idempotency_key: SecureRandom.uuid,
    object: {
      type: "CATEGORY",
      id: category_id.to_s,
      version: version,
      category_data: category_data
    }
  }
)

if result2.success?
  puts "Category updated successfully."
elsif result2.error?
  warn result.errors
end
