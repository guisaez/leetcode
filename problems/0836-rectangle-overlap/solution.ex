defmodule Solution do
  @spec is_rectangle_overlap(rec1 :: [integer], rec2 :: [integer]) :: boolean
  def is_rectangle_overlap([x1, y1, x2, y2], [x3, y3, x4, y4]) do
    x1 < x4 and x3 < x2 and y1 < y4 and y3 < y2
  end
end
