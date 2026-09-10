# Notes

Post-order DFS. Each recursive call returns a 3-tuple for the current subtree:
`{valid_count, subtree_sum, node_count}`

```
def f(node):
  if node is nil:
    return {0, 0, 0}

  {lv, ls, ln} = f(node.left)
  {rv, rs, rn} = f(node.right)

  total_sum   = ls + rs + node.val
  total_nodes = ln + rn + 1
  valid       = lv + rv + (1 if floor(total_sum / total_nodes) == node.val else 0)

  return {valid, total_sum, total_nodes}

answer = first element of f(root)
```
