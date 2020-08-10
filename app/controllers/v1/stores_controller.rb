class V1::StoresController < ApplicationController
  before_action :set_store, only: [:update, :destroy, :stock_item]

  # GET /v1/stores/search
  def search
    @stores = Store.all

    render json: @stores
  end

  # POST /v1/stores
  def create
    @store = Store.new(store_params)

    if @store.save
      render json: @store, status: :created, location: @store
    else
      render json: @store.errors, status: :unprocessable_entity
    end
  end

  # POST /v1/stock_item
  def stock_item
  end

  # PATCH/PUT /v1/stores/1
  def update
    if @store.update(store_params)
      render json: @store
    else
      render json: @store.errors, status: :unprocessable_entity
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

    # Only allow a trusted parameter "white list" through.
    def store_params
      params.require(:store).permit(:name, :address)
    end
end
