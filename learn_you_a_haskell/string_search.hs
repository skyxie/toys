
strSearchStep :: [Char] -> [Char] -> Int -> Int -> Int
strSearchStep a b i aIdx = if take (length b) (drop aIdx a) == b
                           then i + 1
                           else i

strSearch :: [Char] -> [Char] -> Int
strSearch a b = foldl (strSearchStep a b) 0 [0..((length a) - (length b) + 1)]

