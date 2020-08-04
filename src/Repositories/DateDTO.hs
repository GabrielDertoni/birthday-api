module Repositories.DateDTO (parseDate) where

-- External packages
import Data.Maybe
import Text.ParserCombinators.ReadP
-- Project packages
import Repositories.CSVParser (token, integer)
import Entities.Date

date :: ReadP Date
date = do _day <- integer
          char '/'
          _month <- integer
          char '/'
          _year <- integer
          return $ Date { day   = _day
                        , month = _month
                        , year  = _year }

parseDate :: String -> Maybe Date
parseDate str = case readP_to_S date str of
                  [] -> Nothing
                  xs -> Just $ fst $ last xs
