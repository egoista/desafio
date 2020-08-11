require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'validation' do
    describe 'presensence of name' do
      it 'is invalid without name' do
        invalid_product = described_class.new(price: 1)

        expect(invalid_product).to_not be_valid
        expect(invalid_product.errors.details).to eq({ name: [{ error: :blank }] })
      end
    end
    describe 'presensence of price' do
      it 'is invalid without name' do
        invalid_product = described_class.new(name: 'foo')

        expect(invalid_product).to_not be_valid
        expect(invalid_product.errors.details).to eq({ price: [{ error: :blank }] })
      end
    end
  end
end
