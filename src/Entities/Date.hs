module Entities.Date (Date(..)) where

import Text.Printf

data Date = Date { day :: Integer, month :: Integer, year :: Integer }

instance Show Date where
  show date = printf "%02d/%02d/%02d" (day date) (month date) (year date)

instance Eq Date where
  (==) a b = (day a == day b) && (month a == month b) && (year a == year b)

instance Ord Date where
  compare a b
    | year  a /= year  b = compare (year  a) (year  b)
    | month a /= month b = compare (month a) (month b)
    | otherwise = compare (day a) (day b)