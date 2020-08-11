require 'rails_helper'

RSpec.describe V1::StockItemsSerializer do
  describe '#as_json' do
    let(:stock_item) { build(:stock_item) }
    context 'with a valid object' do
      it 'returns a json response' do
        response = described_class.new(stock_item).as_json
        expect(response).to eq({
          'product_id' => stock_item.product_id,
          'quantity' => stock_item.quantity
        })
      end
    end
  end

  describe '.collection_as_json' do
    context 'with an enumerable object' do
      let(:stock_items) { build_list(:stock_item, 2) }
      it 'returns a json array response' do
        response = described_class.collection_as_json(stock_items)
        expected = stock_items.map do |stock_item|
          {
            'product_id' => stock_item.product_id,
            'quantity' => stock_item.quantity
          }
        end
        expect(response).to eq(expected)
      end
    end

    context 'without an enumerable object' do
      let(:stock_items) { build(:stock_item) }
      it 'returns a empty array response' do
        response = described_class.collection_as_json(stock_items)
        expect(response).to eq([])
      end
    end
  end
end
