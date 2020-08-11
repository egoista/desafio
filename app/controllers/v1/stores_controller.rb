class V1::StoresController < ApplicationController
  before_action :set_store, only: [:update, :destroy, :stock_item, :add, :remove]
  before_action :set_stock_item, only: [:add, :remove]
  before_action :validate_quantity, only: [:add, :remove]

  # GET /v1/stores/search
  def search
    @stores = Store.all

    render json: V1::StoresSerializer.collection_as_json(@stores)
  end

  # POST /v1/stores
  def create
    @store = Store.new(store_params)

    if @store.save
      render json: V1::StoresSerializer.new(@store), status: :created
    else
      render_errors(@store.errors.full_messages, :unprocessable_entity)
    end
  end

  # POST /v1/stores/1/stock_item
  def stock_item
    @stock_item = StockItem.create(stock_item_params.merge(store: @store))

    if @stock_item.save
      render json: V1::StoresSerializer.new(@store), status: :created
    else
      render_errors(@stock_item.errors.full_messages, :unprocessable_entity)
    end
  end

  # PATCH/PUT /v1/stores/1/stock_item/1/add/1
  def add
    @stock_item.increment(:quantity, params[:quantity].to_i)
    if @stock_item.save
      render json: V1::StoresSerializer.new(@store)
    else
      render_errors(@stock_item.errors.full_messages, :unprocessable_entity)
    end
  end

  # PATCH/PUT /v1/stores/1/stock_item/1/remove/1
  def remove
    @stock_item.decrement(:quantity, params[:quantity].to_i)
    if @stock_item.save
      render json: V1::StoresSerializer.new(@store)
    else
      render_errors(@stock_item.errors.full_messages, :unprocessable_entity)
    end
  end

  # PATCH/PUT /v1/stores/1
  def update
    if @store.update(store_params)
      render json: V1::StoresSerializer.new(@store)
    else
      render_errors(@store.errors.full_messages, :unprocessable_entity)
    end
  end

  # DELETE /v1/stores/1
  def destroy
    @store.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_store
    @store = Store.find(params[:id])
  end

  def set_stock_item
    @stock_item = StockItem.find_by!(store_id: params[:id], product_id: params[:product_id])
  end

  def validate_quantity
    render_errors(['Quantity must be an integer'], :bad_request) unless params[:quantity] !~ /\D/
  end

  # Only allow a trusted parameter "white list" through.
  def store_params
    params.require(:store).permit(:name, :address)
  end

  def stock_item_params
    params.require(:stock_item).permit(:product_id, :quantity)
  end
end
