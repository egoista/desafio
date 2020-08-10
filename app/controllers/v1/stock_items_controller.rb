class V1::StockItemsController < ApplicationController
  # PATCH/PUT /v1/stock_items/add
  def add
  end

  # PATCH/PUT /v1/stock_items/remove
  def remove
  end

  private
    # Only allow a trusted parameter "white list" through.
    def stock_item_params
      params.require(:stock_item).permit(:quantity, :product_id)
    end
end
