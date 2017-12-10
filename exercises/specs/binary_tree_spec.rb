require 'binary_tree'

describe BinaryTree do

  describe :height do
    subject { tree.height }

    context 'for single root' do
      let(:tree) { BinaryTree.new(1) }
      it { is_expected.to eql(1) }
    end

    context 'when branches have different heights' do
      let(:tree) do
        BinaryTree.new(
          1,
          BinaryTree.new(
            2,
            BinaryTree.new(3)
          ),
          BinaryTree.new(4)
        )
      end

      it { is_expected.to eql(3) }
    end
  end

  describe :size do
    subject { tree.size }

    context 'for single root' do
      let(:tree) { BinaryTree.new(1) }
      it { is_expected.to eql(1) }
    end

    context 'for multiple unbalanced nodes' do
      let(:tree) do
        BinaryTree.new(1,
          BinaryTree.new(2,
            BinaryTree.new(3,
              BinaryTree.new(4)
            )
          )
        )
      end

      it { is_expected.to eql(4) }
    end
  end

  describe :balanced? do
    subject { tree }

    context 'for single root' do
      let(:tree) { BinaryTree.new(1) }
      it { is_expected.to be_balanced }
    end

    context 'for branches of equal size' do
      let(:tree) do
        BinaryTree.new(
          1,
          BinaryTree.new(2),
          BinaryTree.new(3)
        )
      end

      it { is_expected.to be_balanced }
    end

    context 'for imperfect branches of height 3' do
      let(:tree) do
        BinaryTree.new(1,
          BinaryTree.new(2,
            BinaryTree.new(3)
          ),
          BinaryTree.new(4,
            BinaryTree.new(5)
          )
        )
      end

      it { is_expected.to be_balanced }
    end

    context 'for unbalanced branches of the same height' do
      let(:tree) do
        BinaryTree.new(1,
          BinaryTree.new(2,
            BinaryTree.new(4,
              BinaryTree.new(6)
            )
          ),
          BinaryTree.new(3,
            BinaryTree.new(5,
              BinaryTree.new(7)
            )
          )
        )
      end

      it { is_expected.to_not be_balanced }
    end

    context 'for branches where height is off by more than 1' do
      let(:tree) do
        BinaryTree.new(
          1,
          BinaryTree.new(2,
            BinaryTree.new(4,
              BinaryTree.new(6,
                BinaryTree.new(8),
                BinaryTree.new(10)
              )
            )
          ),
          BinaryTree.new(3)
        )
      end

      it { is_expected.to_not be_balanced }
    end
  end

  describe :full? do
    subject { tree }

    context 'for a single root node' do
      let(:tree) { BinaryTree.new(1) }
      it { is_expected.to be_full }
    end

    context 'for tree with both root branches filled' do
      let(:tree) { BinaryTree.new(1, BinaryTree.new(2), BinaryTree.new(3)) }
      it { is_expected.to be_full }
    end

    context 'for tree with 1 root branch filled' do
      let(:tree) { BinaryTree.new(1, BinaryTree.new(2)) }
      it { is_expected.to_not be_full }
    end

    context 'for unbalanced tree with 2 branches at non-leaf nodes' do
      let(:tree) do
        BinaryTree.new(1,
          BinaryTree.new(2,
            BinaryTree.new(4,
              BinaryTree.new(6),
              BinaryTree.new(7),
            ),
            BinaryTree.new(5),
          ),
          BinaryTree.new(3)
        )
      end

      it { is_expected.to be_full }
      it { is_expected.to_not be_balanced }
    end
  end

  describe :complete? do
    subject { tree }

    context 'for a single root node' do
      let(:tree) { BinaryTree.new(1) }
      it { is_expected.to be_complete }
    end

    context 'for tree with both root branches' do
      let(:tree) { BinaryTree.new(1, BinaryTree.new(2), BinaryTree.new(3)) }
      it { is_expected.to be_complete }
    end

    context 'for tree with left root branch' do
      let(:tree) { BinaryTree.new(1, BinaryTree.new(2)) }
      it { is_expected.to be_complete }
    end

    context 'for tree with right root branch' do
      let(:tree) { BinaryTree.new(1, nil, BinaryTree.new(2)) }
      it { is_expected.to_not be_complete }
    end

    context 'for tree with all nodes to far left' do
      let(:tree) do
        BinaryTree.new(1,
          BinaryTree.new(2,
            BinaryTree.new(3)
          )
        )
      end

      it { is_expected.to_not be_complete }
    end

    context 'for tree with gap between nodes' do
      let(:tree) do
        BinaryTree.new(1,
          BinaryTree.new(2,
            nil,
            BinaryTree.new(4)
          ),
          BinaryTree.new(3,
            BinaryTree.new(5)
          )
        )
      end

      it { is_expected.to_not be_complete }
    end
  end

  describe :perfect? do
    subject { tree }

    context 'for a single root node' do
      let(:tree) { BinaryTree.new(1) }
      xit { is_expected.to be_perfect }
    end

    context 'for a small evenly-distributed tree' do
      let(:tree) { BinaryTree.new(1, BinaryTree.new(2), BinaryTree.new(3)) }
      xit { is_expected.to be_perfect }
    end

    context 'for a large evenly-distributed tree' do
      let(:tree) do
        BinaryTree.new(1,
          BinaryTree.new(2,
            BinaryTree.new(4,
              BinaryTree.new(8),
              BinaryTree.new(9)
            ),
            BinaryTree.new(5,
              BinaryTree.new(10),
              BinaryTree.new(11)
            )
          ),
          BinaryTree.new(3,
            BinaryTree.new(6,
              BinaryTree.new(12),
              BinaryTree.new(13)
            ),
            BinaryTree.new(7,
              BinaryTree.new(14),
              BinaryTree.new(15)
            )
          )
        )
      end

      xit { is_expected.to be_perfect }
    end
  end

  describe :create_from_sorted_integers do
    subject(:tree) { BinaryTree.create_from_sorted_integers(list) }

    (1..7).each do |n|
      describe "for #{n} integers" do
        let(:list) { n.times.map { |i| rand(100) }.sort }

        describe :height do
          subject { tree.height }
          it { is_expected.to eql(Math.log(n, 2).to_i + 1) }
        end

        if Math.log(n+1, 2) - Integer(Math.log(n+1, 2)) == 0
          it { is_expected.to be_perfect }
        end
      end
    end
  end
end
