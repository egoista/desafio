require 'rails_helper'

RSpec.describe V1::StoresSerializer do
  describe '#as_json' do
    let(:store) { build(:store) }
    context 'with a valid object' do
      it 'returns a json response' do
        response = described_class.new(store).as_json
        expect(response).to eq({
          'id' => store.id,
          'name' => store.name,
          'address' => store.address,
          'stock_items' => []
        })
      end
    end
  end

  describe '.collection_as_json' do
    context 'with an enumerable object' do
      let(:stores) { build_list(:store, 2) }
      it 'returns a json array response' do
        response = described_class.collection_as_json(stores)
        expected = stores.map do |store|
          {
            'id' => store.id,
            'name' => store.name,
            'address' => store.address,
            'stock_items' => []
          }
        end
        expect(response).to eq(expected)
      end
    end

    context 'without an enumerable object' do
      let(:stores) { build(:store) }
      it 'returns a empty array response' do
        response = described_class.collection_as_json(stores)
        expect(response).to eq([])
      end
    end
  end
end
