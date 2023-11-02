require "rails_helper"

RSpec.describe "Fragrances" do
  describe "GET /index" do
    it "returns http success" do
      get "/fragrances/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/fragrances/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/fragrances/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/fragrances/show"
      expect(response).to have_http_status(:success)
    end
  end
end
