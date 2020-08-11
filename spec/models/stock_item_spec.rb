require 'rails_helper'

RSpec.describe StockItem, type: :model do
  describe 'validation' do
    describe 'uniqueness of product and store' do
      context 'with same product and store' do
        let(:store) { create(:store) }
        let(:product) { create(:product) }
        it 'invalid entity' do
          StockItem.create(product: product, store: store, quantity: 1)
          invalid_item = StockItem.new(product: product, store: store, quantity: 1)
          expect(invalid_item).to_not be_valid
        end
      end

      context 'with different product' do
        let(:store) { create(:store) }
        let(:product_1) { create(:product) }
        let(:product_2) { create(:product) }
        it 'valid entity' do
          StockItem.create(product: product_1, store: store, quantity: 1)
          invalid_item = StockItem.new(product: product_2, store: store, quantity: 1)
          expect(invalid_item).to be_valid
        end
      end

      context 'with different store' do
        let(:store_1) { create(:store) }
        let(:store_2) { create(:store) }
        let(:product) { create(:product) }
        it 'valid entity' do
          StockItem.create(product: product, store: store_1, quantity: 1)
          invalid_item = StockItem.new(product: product, store: store_2, quantity: 1)
          expect(invalid_item).to be_valid
        end
      end
    end

    let(:store) { create(:store) }
    let(:product) { create(:product) }

    describe 'presensence of quantity' do
      it 'is invalid without name' do
        invalid_item = described_class.new(product: product, store: store)

        expect(invalid_item).to_not be_valid
        expect(invalid_item.errors.details).to eq({ quantity: [{:error=>:not_a_number, :value=>nil}, {:error=>:blank}] })
      end
    end

    describe 'presensence of product' do
      it 'is invalid without product' do
        invalid_item = described_class.new(quantity: 1, store: store)

        expect(invalid_item).to_not be_valid
        expect(invalid_item.errors.details).to eq({ product: [{ error: :blank }] })
      end
    end

    describe 'presensence of store' do
      it 'is invalid without store' do
        invalid_item = described_class.new(quantity: 1, product: product)

        expect(invalid_item).to_not be_valid
        expect(invalid_item.errors.details).to eq({ store: [{ error: :blank }] })
      end
    end
  end
end
