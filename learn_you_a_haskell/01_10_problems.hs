--
-- Solutions to 99 Questions: https://wiki.haskell.org/99_questions/1_to_10
--

-- 1. Last (w/o using last)
myLast :: [a] -> a
myLast [] = error "Empty list!"
myLast (x:[]) = x
myLast (x:xs) = myLast xs

-- 2. Init (w/o using init)
myButLast :: [a] -> a
myButLast [] = error "Empty list!"
myButLast (x:[]) = error "List of length 1!"
myButLast (x:y:[]) = x
myButLast (x:xs) = myButLast xs

-- 3. elementAt (w/o using !!)
elementAt :: [a] -> Int -> a
elementAt [] _ = error "Index exceeds length of list"
elementAt (x:_) 1 = x
elementAt (x:xs) k = elementAt xs (k-1)

-- 4. length (w/o using length)
myLength :: [a] -> Int
myLength [] = 0
myLength (x:xs) = 1 + myLength xs

-- 5. reverse (w/o using reverse)
_flipPrepend :: [a] -> a -> [a]
_flipPrepend xs x = x:xs

myReverse :: [a] -> [a]
myReverse xs = foldl _flipPrepend [] xs

-- 6. palindrome
_isPalindromeStep :: Eq a => Int -> [a] -> Bool
_isPalindromeStep i xs = i > (floor ((fromIntegral (myLength xs)) / 2.0)) || (((elementAt xs (i + 1)) == (elementAt xs ((myLength xs) - i))) && (_isPalindromeStep (i + 1) xs))

isPalindrome :: Eq a => [a] -> Bool
isPalindrome = _isPalindromeStep 0

-- 7. flatten
data NestedList a = Elem a | List [NestedList a]

flatten :: NestedList a -> [a]
flatten (Elem x) = [x]
flatten (List []) = []
flatten (List (x:xs)) = foldl (++) (flatten x) [flatten x' | x' <- xs]

-- 8. Eliminate consecutive duplicates
pushBack :: [a] -> a -> [a]
pushBack xs x = reverse (x:(reverse xs))

_compressStep :: Eq a => [a] -> a -> [a]
_compressStep [] x = [x]
_compressStep xs x = if myLast xs == x
                     then xs
                     else pushBack xs x

compress :: Eq a => [a] -> [a]
compress [] = []
compress xs = foldl _compressStep [] xs

-- 9. Group consecutive duplicates
_packStep :: Eq a => [[a]] -> a -> [[a]]
_packStep g x = if (head (myLast g)) == x
                then pushBack (take ((myLength g) - 1) g) (x:(myLast g))
                else pushBack g [x]

pack :: Eq a => [a] -> [[a]]
pack [] = [[]]
pack (x:[]) = [[x]]
pack (x:xs) = foldl _packStep [[x]] xs

-- 10. Length encoding
_encodeStep :: Eq a => Integral i => [(i, a)] -> a -> [(i, a)]
_encodeStep g x = if (snd (myLast g)) == x
                  then pushBack (take ((myLength g) - 1) g) (((fst (myLast g)) + 1), (snd (myLast g)))
                  else pushBack g (1, x)

encode :: Eq a => Integral i => [a] -> [(i, a)]
encode [] = []
encode (x:[]) = [(1, x)]
encode (x:xs) = foldl _encodeStep [(1, x)] xs




