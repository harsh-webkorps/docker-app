RSpec.describe AddService do
  context 'add' do
    it 'adds two numbers' do
      result = AddService.new.add(1,2)
      expect(result).to eq(4)
    end
  end
end