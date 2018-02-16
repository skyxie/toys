class BinaryTree:
    def __init__(self, val, l, r):
        self.value = val
        self.left = l
        self.right = r

    def height(self, at_each_node=None):
        left_height = self.left.height(at_each_node) if self.left else 0
        right_height = self.right.height(at_each_node) if self.right else 0
        if callable(at_each_node):
            # Allow code to be executed once left and right height are known
            at_each_node(left_height, right_height)
        return 1 + max(left_height, right_height)

    def balanced(self):
        results = list()
        self.height(lambda lh, rh: results.append(1 if abs(lh - rh) > 1 else 0))
        return sum(results) == 0

    @staticmethod
    def create_tree_from_sorted_list(vals):
        if not vals:
            return None
        size = len(vals)
        pivot = size / 2
        return BinaryTree(
            vals[pivot],
            create_tree_from_sorted_list(vals[0:pivot]),
            create_tree_from_sorted_list(vals[(pivot+1):size])
        )

