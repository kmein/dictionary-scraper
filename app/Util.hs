module Util where

import Data.Char (isSpace)
import Text.HTML.Scalpel

text' :: Selector -> Scraper String String
text' = fmap trim . text
  where trim = f . f where f = reverse . dropWhile isSpace

listToMaybe' :: [a] -> Maybe [a]
listToMaybe' [] = Nothing
listToMaybe' x = Just x
