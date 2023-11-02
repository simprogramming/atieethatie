require "rails_helper"

RSpec.describe "FragranceProfiles" do
  describe "GET /index" do
    it "returns http success" do
      get "/fragrance_profiles/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/fragrance_profiles/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/fragrance_profiles/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/fragrance_profiles/edit"
      expect(response).to have_http_status(:success)
    end
  end
end
