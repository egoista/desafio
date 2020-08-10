require "rails_helper"

RSpec.describe StockItemsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/stock_items").to route_to("stock_items#index")
    end

    it "routes to #show" do
      expect(get: "/stock_items/1").to route_to("stock_items#show", id: "1")
    end


    it "routes to #create" do
      expect(post: "/stock_items").to route_to("stock_items#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/stock_items/1").to route_to("stock_items#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/stock_items/1").to route_to("stock_items#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/stock_items/1").to route_to("stock_items#destroy", id: "1")
    end
  end
end
