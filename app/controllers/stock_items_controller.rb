class StockItemsController < ApplicationController
  before_action :set_stock_item, only: [:show, :update, :destroy]

  # GET /stock_items
  def index
    @stock_items = StockItem.all

    render json: @stock_items
  end

  # GET /stock_items/1
  def show
    render json: @stock_item
  end

  # POST /stock_items
  def create
    @stock_item = StockItem.new(stock_item_params)

    if @stock_item.save
      render json: @stock_item, status: :created, location: @stock_item
    else
      render json: @stock_item.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /stock_items/1
  def update
    if @stock_item.update(stock_item_params)
      render json: @stock_item
    else
      render json: @stock_item.errors, status: :unprocessable_entity
    end
  end

  # DELETE /stock_items/1
  def destroy
    @stock_item.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stock_item
      @stock_item = StockItem.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def stock_item_params
      params.require(:stock_item).permit(:quantity, :product_id, :store_id)
    end
end
