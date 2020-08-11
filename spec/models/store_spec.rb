require 'rails_helper'

RSpec.describe Store, type: :model do
  describe 'validation' do
    describe 'presensence of name' do
      it 'is invalid without name' do
        invalid_store = described_class.new(address: 'adrress')

        expect(invalid_store).to_not be_valid
        expect(invalid_store.errors.details).to eq({ name: [{ error: :blank }] })
      end
    end

    describe 'presensence of address' do
      it 'is invalid without name' do
        invalid_store = described_class.new(name: 'name')

        expect(invalid_store).to_not be_valid
        expect(invalid_store.errors.details).to eq({ address: [{ error: :blank }] })
      end
    end
  end
end
