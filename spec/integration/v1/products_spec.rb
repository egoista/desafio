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
          price: { type: :number }
        },
        required: %w[name price]
      }

      response '201', 'product created' do
        let(:product) { { name: 'foo', price: 1.1 } }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data.keys).to match_array(%w[name price])
          expect(data['name']).to eq('foo')
          expect(data['price']).to eq(1.1)
        end
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

  path '/v1/products/{id}' do
    put 'Updates a product' do
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
        let(:id) { saved_product.id }
        let(:product) { { name: 'foo' } }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data.keys).to match_array(%w[name price])
          expect(data['name']).to eq('foo')
          expect(data['price']).to eq(saved_product.price)
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
        let(:id) { saved_product.id }
        let(:product) { { name: 'foo' } }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data.keys).to match_array(%w[name price])
          expect(data['name']).to eq('foo')
          expect(data['price']).to eq(saved_product.price)
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
