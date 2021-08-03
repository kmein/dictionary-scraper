module Util where

import Data.Char (isSpace)
import Data.Text (Text, strip)
import Text.HTML.Scalpel

text' :: Selector -> Scraper Text Text
text' = fmap strip . text

listToMaybe' :: [a] -> Maybe [a]
listToMaybe' [] = Nothing
listToMaybe' x = Just x
