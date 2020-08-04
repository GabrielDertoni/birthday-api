module Repositories.CSVParser where

import Data.Char
import Text.ParserCombinators.ReadP
import Control.Applicative ((<|>), some)
import Entities.Date (Date(..))

data CSValue
  = CSString  String
  | CSInteger Integer
  | CSDouble  Double
  | CSDate    Date
  deriving (Eq, Show)

type CSVLine = [CSValue]
type CSVTable = [CSVLine]

space :: ReadP ()
space = do many (satisfy isSpace)
           return ()

token :: ReadP a -> ReadP a
token p = do space
             v <- p
             space
             return v

symbol :: String -> ReadP String
symbol str = token (string str)

digit :: ReadP Char
digit = satisfy isDigit

stringLiteral :: ReadP String
stringLiteral = between (char '"') (char '"') (many $ satisfy (/= '"'))

integer :: ReadP Integer
integer = read <$> (some digit)

double :: ReadP Double
double = read <$> (do int <- many digit
                      char '.'
                      dec <- many digit
                      return (int <> "." <> dec))

csString :: ReadP CSValue
csString = return CSString <*> token stringLiteral

csInteger :: ReadP CSValue
csInteger = return CSInteger <*> token integer

csDouble :: ReadP CSValue
csDouble = return CSDouble <*> token double

csDate :: ReadP CSValue
csDate = token (do _day   <- integer
                   char '/'
                   _month <- integer
                   char '/'
                   _year  <- integer
                   return $ CSDate $ Date { day = _day, month = _month, year = _year})

csValue :: ReadP CSValue
csValue = csString
      <|> csDate
      <|> csDouble
      <|> csInteger

csvLine :: ReadP CSVLine
csvLine = do v  <- csValue
             vs <- many $ (do char ','
                              csValue)
             return (v:vs)

csvTable :: ReadP CSVTable
csvTable = do line  <- csvLine
              lines <- many $ (do char '\n'
                                  csvLine)
              return (line:lines)

maybeParse :: ReadP a -> String -> Maybe a
maybeParse p str = case readP_to_S p str of
                    [] -> Nothing
                    xs -> Just $ fst $ last xs

extractValues :: [([v], String)] -> [v]
extractValues val
  | null val = []
  | otherwise = fst $ last val

parseCSV :: String -> CSVTable
parseCSV = extractValues . readP_to_S csvTable

readParseCSV :: FilePath -> IO ()
readParseCSV path = do contents <- readFile path
                       print $ parseCSV contents


getCSVColumn :: Int -> CSVLine -> Maybe CSValue
getCSVColumn index line
  | length line >= index = Just $ line !! (index-1)
  | otherwise = Nothing