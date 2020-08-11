require 'swagger_helper'

describe 'Products V1 API' do

  path '/v1/products' do
    post 'Creates a product' do
      tags 'Products'
      consumes 'application/json'
      parameter name: :product, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          price: { type: :number_float }
        },
        required: %w[name price]
      }

      response '201', 'product created' do
        schema type: :object, properties: {
          id: { type: :integer },
          name: { type: :string },
          price: { type: :number_float }
        }, required: %w[name price]

        let(:product) { { name: 'foo', price: 1.1 } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:product) { { name: 'foo' } }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['errors']).to match_array(["Price can't be blank"])
        end
      end
    end
  end

  path '/v1/products/search' do
    get 'Search for products' do
      tags 'Products'
      consumes 'application/json'
      parameter name: :'ids[]', in: :query, type: :array, schema: {
        type: :array,
        items: { type: :integer }
      }, collectionFormat: :multi

      let(:product_1) { create(:product) }
      let(:product_2) { create(:product) }

      response '200', 'products found' do
        schema type: :array, items: { type: :object, properties: {
          id: { type: :integer },
          name: { type: :string },
          price: { type: :number_float }
        }, required: %w[name price] }
        let('ids[]') { [product_1.id, product_2.id] }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data.count).to eq(2)

          expect(data[0]).to eq({
            'id' => product_1.id,
            'name' => product_1.name,
            'price' => product_1.price
          })
          expect(data[1]).to eq({
            'id' => product_2.id,
            'name' => product_2.name,
            'price' => product_2.price
          })
        end
      end
    end
  end

  path '/v1/products/{id}' do
    put 'Updates a product' do
      tags 'Products'
      consumes 'application/json'
      parameter name: :product, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          price: { type: :number_float }
        },
        required: %w[name price]
      }
      parameter name: :id, in: :path, type: :integer
      let(:saved_product) { create(:product) }

      response '200', 'product updated' do
        schema type: :object, properties: {
          id: { type: :integer },
          name: { type: :string },
          price: { type: :number_float }
        }, required: %w[name price]
        let(:id) { saved_product.id }
        let(:product) { { name: 'foo' } }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to eq({
            'id' => id,
            'name' => 'foo',
            'price' => saved_product.price
          })
        end
      end

      response '404', 'invalid request' do
        let(:id) { 'invalid' }
        let(:product) { { name: 'foo' } }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['errors']).to match_array(["Couldn't find Product with 'id'=invalid"])
        end
      end
    end

    patch 'Updates a product' do
      tags 'Products'
      consumes 'application/json'
      parameter name: :product, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          price: { type: :number }
        },
        required: %w[name price]
      }
      parameter name: :id, in: :path, type: :integer
      let(:saved_product) { create(:product) }

      response '200', 'product updated' do
        schema type: :object, properties: {
          id: { type: :integer },
          name: { type: :string },
          price: { type: :number_float }
        }, required: %w[name price]
        let(:id) { saved_product.id }
        let(:product) { { name: 'foo' } }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to eq({
            'id' => id,
            'name' => 'foo',
            'price' => saved_product.price
          })
        end
      end

      response '404', 'invalid request' do
        let(:id) { 'invalid' }
        let(:product) { { name: 'foo' } }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['errors']).to match_array(["Couldn't find Product with 'id'=invalid"])
        end
      end
    end

    delete 'Destroys a product' do
      tags 'Products'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :integer
      let(:saved_product) { create(:product) }

      response '204', 'product destroyed' do
        let(:id) { saved_product.id }
        let(:product) { { name: 'foo' } }
        run_test!
      end

      response '404', 'invalid request' do
        let(:id) { 'invalid' }
        let(:product) { { name: 'foo' } }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['errors']).to match_array(["Couldn't find Product with 'id'=invalid"])
        end
      end
    end
  end
end
