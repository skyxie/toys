from binary_tree import BinaryTree

def test_single_node():
    tree = BinaryTree(1, None, None)
    assert tree.height() == 1
    assert tree.balanced()

def test_perfect_tree():
    tree = BinaryTree(1,
        BinaryTree(2, None, None),
        BinaryTree(3, None, None)
    )
    assert tree.height() == 2
    assert tree.balanced()

def test_balanced_tree():
    tree = BinaryTree(1,
        None,
        BinaryTree(3, None, None)
    )
    assert tree.height() == 2
    assert tree.balanced()

def test_very_unbalanced_tree():
    tree = BinaryTree(1,
        None,
        BinaryTree(2,
            None,
            BinaryTree(3, None, None)
        )
    )
    assert tree.height() == 3
    assert not tree.balanced()

