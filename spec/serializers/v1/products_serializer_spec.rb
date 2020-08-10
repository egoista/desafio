require 'rails_helper'

RSpec.describe V1::ProductsSerializer do
  describe '#as_json' do
    let(:product) { build(:product) }
    context 'with a valid object' do
      it 'returns a json response' do
        response = described_class.new(product).as_json
        expect(response).to eq({
          'name' => product.name,
          'price' => product.price
        })
      end
    end
  end

  describe '.collection_as_json' do
    context 'with an enumerable object' do
      let(:products) { build_list(:product, 2) }
      it 'returns a json array response' do
        response = described_class.collection_as_json(products)
        expect(response).to eq(products.map { |product| { 'name' => product.name, 'price' => product.price } })
      end
    end

    context 'without an enumerable object' do
      let(:products) { build(:product) }
      it 'returns a empty array response' do
        response = described_class.collection_as_json(products)
        expect(response).to eq([])
      end
    end
  end
end
