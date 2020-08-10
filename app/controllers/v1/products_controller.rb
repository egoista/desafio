class V1::ProductsController < ApplicationController
  before_action :set_product, only: [:update, :destroy]

  # GET /v1/products/search
  def search
    @products = Product.find(params[:ids])

    render json: @products
  end

  # POST /v1/products
  def create
    @product = Product.new(product_params)

    if @product.save
      render json: V1::ProductsSerializer.new(@product), status: :created
    else
      render_errors(@product.errors.full_messages, :unprocessable_entity)
    end
  end

  # PATCH/PUT /v1/products/1
  def update
    if @product.update(product_params)
      render json: V1::ProductsSerializer.new(@product)
    else
      render_errors(@product.errors.full_messages, :unprocessable_entity)
    end
  end

  # DELETE /v1/products/1
  def destroy
    @product.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_product
    @product = Product.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def product_params
    params.require(:product).permit(:name, :price)
  end
end
