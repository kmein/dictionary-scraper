{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}

module Cambridge where

import Control.Applicative
import Data.Text (Text)
import Text.HTML.Scalpel
import Types
import Util

url :: String
url = "dictionary.cambridge.org"

scrapeSynonym :: Scraper Text Synonym
scrapeSynonym = do
  synonym <- text' $ "span" @: [hasClass "x-h"]
  synonymUsage <- optional $ text' $ "span" @: [hasClass "usage"]
  region <- optional $ text' $ "span" @: [hasClass "region"]
  info <- optional $ text' $ "span" @: [hasClass "x-num"]
  return Synonym {..}

scrapeDefinitions :: Scraper Text [Definition]
scrapeDefinitions =
  chroots ("div" @: [hasClass "dsense"]) $ do
    note <- optional $ text' $ "span" @: [hasClass "dvar"]
    definiendum <- optional $ text' $ "span" @: [hasClass "dsense_hw"]
    partOfSpeech <- optional $ text' $ "span" @: [hasClass "dsense_pos"]
    guideWord <- optional $ text' $ "span" @: [hasClass "dsense_gw"]
    usage <- optional $ text' $ "span" @: [hasClass "dusage"]
    grammar <- optional $ text' $ "span" @: [hasClass "dgram"]
    level <- optional $ text' $ "span" @: [hasClass "dxref"]
    definiens <- optional $ text' $ "div" @: [hasClass "def"]
    examples <- fmap listToMaybe' $ texts $ "span" @: [hasClass "eg", hasClass "deg"]
    synonyms <- listToMaybe' <$> chroots ("div" @: [hasClass "synonyms"] // "div" @: [hasClass "item"]) scrapeSynonym
    return Definition {..}

getDefinitions :: String -> IO (Maybe [Definition])
getDefinitions query = scrapeURL ("https://" ++ url ++ "/dictionary/english/" ++ query) scrapeDefinitions
