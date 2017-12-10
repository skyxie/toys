require 'linked_list'

describe LinkedList do
  describe :eql? do
    it 'should be eql by value' do
      expect(LinkedList.new(1, LinkedList.new(2))).to eql(
        LinkedList.new(1, LinkedList.new(2)))
    end

    it 'should not be eql if values are different' do
      expect(LinkedList.new(1, LinkedList.new(2))).to_not eql(
        LinkedList.new(1, LinkedList.new(3)))
    end

    it 'should not be eql if lengths are different' do
      expect(LinkedList.new(1, LinkedList.new(2))).to_not eql(
        LinkedList.new(1, LinkedList.new(2, LinkedList.new(3))))
    end
  end
end
