require 'square'

client = Square::Client.new(
  access_token: ENV.fetch('SQUARE_ACCESS_TOKEN'),
  environment: 'sandbox',
  timeout: 1
)

catalog_api = client.catalog

# Prepare the parameters for the API call


# Make the API call to list all items
result = catalog_api.list_catalog

if result.success?
  puts result.data
elsif result.error?
  warn result.errors
end
