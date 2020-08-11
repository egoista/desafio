require 'swagger_helper'

describe 'Stores V1 API' do

  path '/v1/stores' do
    post 'Creates a store' do
      tags 'Stores'
      consumes 'application/json'
      parameter name: :store, in: :body, schema: {
        type: :object,
        properties: {
          store: {
            type: :object,
            properties: {
              name: { type: :string },
              address: { type: :string }
            },
            required: %w[name address]
          }
        },
        required: %w[store]
      }

      response '201', 'store created' do
        # schema type: :object, properties: {
        #   id: { type: :integer },
        #   name: { type: :string },
        #   stock_items: { type: :array },
        #   address: { type: :string }
        # }, required: %w[name address id stock_items]
        examples 'application/json' => {
          id: 1,
          name: 'Hello world!',
          address: '...',
          stock_items: []
        }

        let(:store) { { name: 'foo', address: 'rua bar' } }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data.keys).to match_array(%w[id name address stock_items])
        end
      end

      response '422', 'invalid request' do
        let(:store) { { name: 'foo' } }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['errors']).to match_array(["Address can't be blank"])
        end
      end
    end
  end

  path '/v1/stores/{id}/stock_item' do
    post 'Register a stock item for the store' do
      tags 'Stores'
      consumes 'application/json'
      parameter name: :stock_item, in: :body, schema: {
        type: :object,
        properties: {
          stock_item: {
            type: :object,
            properties: {
              quantity: { type: :integer },
              product_id: { type: :integer }
            },
            required: %w[quantity product_id]
          }
        },
        required: %w[stock_item]
      }
      parameter name: :id, in: :path, type: :integer

      let(:product) { create(:product) }
      let(:store) { create(:store) }
      let(:id) { store.id }

      response '201', 'stock item created' do
        schema type: :object, properties: {
          id: { type: :integer },
          name: { type: :string },
          stock_items: { type: :array },
          address: { type: :string }
        }, required: %w[name address id stock_items]

        let(:stock_item) { { stock_item: { product_id: product.id, quantity: 1 } } }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data.keys).to match_array(%w[id name address stock_items])
          expect(data['stock_items']).to eq([{ 'product_id' => product.id, 'quantity' => 1 }])
        end
      end

      response '422', 'invalid request' do
        let(:stock_item) { { stock_item: { product_id: product.id } } }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['errors']).to match_array(["Quantity can't be blank", "Quantity is not a number"])
        end
      end

      response '412', 'invalid request' do
        before do
          expect_any_instance_of(StockItem).to receive(:save).and_raise(ActiveRecord::StatementInvalid)
        end
        let(:stock_item) { { stock_item: { product_id: product.id } } }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['errors']).to match_array(["Data inconsistency."])
        end
      end
    end
  end

  path '/v1/stores/{id}/stock_item/{product_id}/add/{quantity}' do
    put 'add a quantity to a stock item' do
      tags 'Stores'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :integer
      parameter name: :product_id, in: :path, type: :integer
      parameter name: :quantity, in: :path, type: :integer

      let(:store) { create(:store) }
      let(:id) { store.id }
      let(:product) { create(:product) }
      let(:product_id) { product.id }
      let(:quantity) { 1 }
      let!(:stock_item) { create(:stock_item, store: store, product: product, quantity: 1) }

      response '200', 'store item incremented' do
        run_test! do |response|
          data = JSON.parse(response.body)
          expected = {
            'id' => store.id,
            'name' => store.name,
            'address' => store.address,
            'stock_items' => [{ 'product_id' => product.id, 'quantity' => 2 }]
          }
          expect(data).to eq(expected)
        end
      end

      response '404', 'record not found' do
        let(:product_id) { 'invalid' }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['errors']).to match_array(["Couldn't find StockItem"])
        end
      end

      response '400', 'bad request' do
        let(:quantity) { 'invalid' }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['errors']).to match_array(["Quantity must be an integer"])
        end
      end
    end

    patch 'add a quantity to a stock item' do
      tags 'Stores'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :integer
      parameter name: :product_id, in: :path, type: :integer
      parameter name: :quantity, in: :path, type: :integer

      let(:store) { create(:store) }
      let(:id) { store.id }
      let(:product) { create(:product) }
      let(:product_id) { product.id }
      let(:quantity) { 1 }
      let!(:stock_item) { create(:stock_item, store: store, product: product, quantity: 1) }

      response '200', 'store item incremented' do
        run_test! do |response|
          data = JSON.parse(response.body)
          expected = {
            'id' => store.id,
            'name' => store.name,
            'address' => store.address,
            'stock_items' => [{ 'product_id' => product.id, 'quantity' => 2 }]
          }
          expect(data).to eq(expected)
        end
      end

      response '404', 'record not found' do
        let(:product_id) { 'invalid' }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['errors']).to match_array(["Couldn't find StockItem"])
        end
      end

      response '400', 'bad request' do
        let(:quantity) { 'invalid' }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['errors']).to match_array(["Quantity must be an integer"])
        end
      end
    end
  end

  path '/v1/stores/{id}/stock_item/{product_id}/remove/{quantity}' do
    put 'remove a quantity from a stock item' do
      tags 'Stores'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :integer
      parameter name: :product_id, in: :path, type: :integer
      parameter name: :quantity, in: :path, type: :integer

      let(:store) { create(:store) }
      let(:id) { store.id }
      let(:product) { create(:product) }
      let(:product_id) { product.id }
      let(:quantity) { 1 }
      let!(:stock_item) { create(:stock_item, store: store, product: product, quantity: 1) }

      response '200', 'store item incremented' do
        run_test! do |response|
          data = JSON.parse(response.body)
          expected = {
            'id' => store.id,
            'name' => store.name,
            'address' => store.address,
            'stock_items' => [{ 'product_id' => product.id, 'quantity' => 0 }]
          }
          expect(data).to eq(expected)
        end
      end

      response '422', 'negative quantity' do
        let(:quantity) { 4 }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['errors']).to match_array(["Quantity must be greater than or equal to 0"])
        end
      end

      response '404', 'record not found' do
        let(:product_id) { 'invalid' }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['errors']).to match_array(["Couldn't find StockItem"])
        end
      end

      response '400', 'bad request' do
        let(:quantity) { 'invalid' }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['errors']).to match_array(["Quantity must be an integer"])
        end
      end
    end

    patch 'remove a quantity from a stock item' do
      tags 'Stores'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :integer
      parameter name: :product_id, in: :path, type: :integer
      parameter name: :quantity, in: :path, type: :integer

      let(:store) { create(:store) }
      let(:id) { store.id }
      let(:product) { create(:product) }
      let(:product_id) { product.id }
      let(:quantity) { 1 }
      let!(:stock_item) { create(:stock_item, store: store, product: product, quantity: 1) }

      response '200', 'store item incremented' do
        run_test! do |response|
          data = JSON.parse(response.body)
          expected = {
            'id' => store.id,
            'name' => store.name,
            'address' => store.address,
            'stock_items' => [{ 'product_id' => product.id, 'quantity' => 0 }]
          }
          expect(data).to eq(expected)
        end
      end

      response '422', 'negative quantity' do
        let(:quantity) { 4 }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['errors']).to match_array(["Quantity must be greater than or equal to 0"])
        end
      end

      response '404', 'record not found' do
        let(:product_id) { 'invalid' }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['errors']).to match_array(["Couldn't find StockItem"])
        end
      end

      response '400', 'bad request' do
        let(:quantity) { 'invalid' }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['errors']).to match_array(["Quantity must be an integer"])
        end
      end
    end
  end

  path '/v1/stores/search' do
    get 'Search for stores' do
      tags 'Stores'
      consumes 'application/json'
      parameter name: :'ids[]', in: :query, type: :array, schema: {
        type: :array,
        items: { type: :integer }
      }, collectionFormat: :multi

      let(:store_1) { create(:store) }
      let(:store_2) { create(:store) }

      response '200', 'stores found' do
        schema type: :array, items: { type: :object, properties: {
          id: { type: :integer },
          stock_items: { type: :array },
          name: { type: :string },
          address: { type: :string }
        }, required: %w[id name address stock_items] }
        let('ids[]') { [store_1.id, store_2.id] }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data.count).to eq(2)

          expect(data[0]).to eq({
            'id' => store_1.id,
            'name' => store_1.name,
            'address' => store_1.address,
            'stock_items' => []
          })
          expect(data[1]).to eq({
            'id' => store_2.id,
            'name' => store_2.name,
            'address' => store_2.address,
            'stock_items' => []
          })
        end
      end
    end
  end

  path '/v1/stores/{id}' do
    put 'Updates a store' do
      tags 'Stores'
      consumes 'application/json'
      parameter name: :store, in: :body, schema: {
        type: :object,
        properties: {
          store: {
            type: :object,
            properties: {
              name: { type: :string },
              address: { type: :string }
            },
            required: %w[name address]
          }
        },
        required: %w[store]
      }
      parameter name: :id, in: :path, type: :integer
      let(:saved_store) { create(:store) }

      response '200', 'store updated' do
        schema type: :object, properties: {
          name: { type: :string },
          id: { type: :integer },
          stock_items: { type: :array },
          address: { type: :string }
        }, required: %w[name address id stock_items]
        let(:id) { saved_store.id }
        let(:store) { { store: { name: 'foo' } } }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to eq({
            'id' => saved_store.id,
            'name' => 'foo',
            'address' => saved_store.address,
            'stock_items' => []
          })
        end
      end

      response '404', 'invalid request' do
        let(:id) { 'invalid' }
        let(:store) { { name: 'foo' } }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['errors']).to match_array(["Couldn't find Store with 'id'=invalid"])
        end
      end
    end

    patch 'Updates a store' do
      tags 'Stores'
      consumes 'application/json'
      parameter name: :store, in: :body, schema: {
        type: :object,
        properties: {
          store: {
            type: :object,
            properties: {
              name: { type: :string },
              address: { type: :string }
            },
            required: %w[name address]
          }
        },
        required: %w[store]
      }
      parameter name: :id, in: :path, type: :integer
      let(:saved_store) { create(:store) }

      response '200', 'store updated' do
        schema type: :object, properties: {
          id: { type: :integer },
          stock_items: { type: :array },
          name: { type: :string },
          address: { type: :string }
        }, required: %w[id name address stock_items]
        let(:id) { saved_store.id }
        let(:store) { { store: { name: 'foo' } } }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to eq({
            'id' => saved_store.id,
            'name' => 'foo',
            'address' => saved_store.address,
            'stock_items' => []
          })
        end
      end

      response '404', 'invalid request' do
        let(:id) { 'invalid' }
        let(:store) { { name: 'foo' } }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['errors']).to match_array(["Couldn't find Store with 'id'=invalid"])
        end
      end
    end

    delete 'Destroys a store' do
      tags 'Stores'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :integer
      let(:saved_store) { create(:store) }

      response '204', 'store destroyed' do
        let(:id) { saved_store.id }
        let(:store) { { name: 'foo' } }
        run_test!
      end

      response '404', 'invalid request' do
        let(:id) { 'invalid' }
        let(:store) { { store: { name: 'foo' } } }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['errors']).to match_array(["Couldn't find Store with 'id'=invalid"])
        end
      end
    end
  end
end
