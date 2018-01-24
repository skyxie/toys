--
-- Solutions to 99 Questions: https://wiki.haskell.org/99_questions/1_to_10
--

-- 1. Implement last (w/o using last)
myLast :: [a] -> a
myLast [] = error "Empty list!"
myLast (x:[]) = x
myLast (x:xs) = myLast xs

-- 2. Implement init (w/o using init)
myButLast :: [a] -> a
myButLast [] = error "Empty list!"
myButLast (x:[]) = error "List of length 1!"
myButLast (x:y:[]) = x
myButLast (x:xs) = myButLast xs

-- 3. Implement elementAt (without using !!)
elementAt :: [a] -> Int -> a
elementAt [] _ = error "Index exceeds length of list"
elementAt (x:_) 1 = x
elementAt (x:xs) k = elementAt xs (k-1)

-- 4. Implement length
myLength :: [a] -> Int
myLength [] = 0
myLength (x:xs) = 1 + myLength xs

-- 5. Implement reverse
_flipPrepend :: [a] -> a -> [a]
_flipPrepend xs x = x:xs

myReverse :: [a] -> [a]
myReverse xs = foldl _flipPrepend [] xs

-- 6. Implement palindrome
_isPalindromeStep :: Eq a => Int -> [a] -> Bool
_isPalindromeStep i xs = i > (floor ((fromIntegral (myLength xs)) / 2.0)) || (((elementAt xs (i + 1)) == (elementAt xs ((myLength xs) - i))) && (_isPalindromeStep (i + 1) xs))

isPalindrome :: Eq a => [a] -> Bool
isPalindrome = _isPalindromeStep 0

