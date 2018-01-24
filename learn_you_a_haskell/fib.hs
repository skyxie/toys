
-- Recursively calculate nth fibonacci number
fibRecur :: Int -> Int
fibRecur n = if n < 2
             then 1
             else fibRecur (n-1) + fibRecur (n-2)

-- Iteratively calculate nth fibonacci number
fibIt :: Int -> Int
fibIt n = head (foldl fibItStep [] [0..n])

fibItStep :: [Int] -> a -> [Int]
fibItStep xs _ = if length xs < 2
                 then 1 : xs
                 else (sum (take 2 xs)) : (take 2 xs)

