{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}
module Cambridge where

import Control.Applicative
import Text.HTML.Scalpel
import Util
import Types

url :: String
url = "dictionary.cambridge.org"

scrapeEntry :: Scraper String Entry
scrapeEntry = do
  entry <- text' $ ("div" @: [hasClass "pos-header"]) // ("span" @: [hasClass "headword"]) // ("span" @: [hasClass "hw"])
  senses <- chroots ("div" @: [hasClass "dsense"]) scrapeSense
  return Entry {..}

scrapeSynonym :: Scraper String Synonym
scrapeSynonym = do
  synonym <- text' $ "span" @: [hasClass "x-h"]
  synonymUsage <- optional $ text' $ "span" @: [hasClass "usage"]
  region <- optional $ text' $ "span" @: [hasClass "region"]
  info <- optional $ text' $ "span" @: [hasClass "x-num"]
  return Synonym {..}

scrapeSense :: Scraper String Sense
scrapeSense = do
  note <- optional $ text' $ "span" @: [hasClass "dvar"]
  sense <- optional $ text' $ "span" @: [hasClass "dsense_hw"]
  partOfSpeech <- optional $ text' $ "span" @: [hasClass "dsense_pos"]
  guideWord <- optional $ text' $ "span" @: [hasClass "dsense_gw"]
  usage <- optional $ text' $ "span" @: [hasClass "dusage"]
  grammar <- optional $ text' $ "span" @: [hasClass "dgram"]
  level <- optional $ text' $ "span" @: [hasClass "dxref"]
  definition <- optional $ text' $ "div" @: [hasClass "def"]
  examples <- fmap listToMaybe' $ texts $ "span" @: [hasClass "eg", hasClass "deg"]
  synonyms <- listToMaybe' <$> chroots ("div" @: [hasClass "synonyms"] // "div" @: [hasClass "item"]) scrapeSynonym
  return Sense {..}

getEntry :: String -> IO (Maybe Entry)
getEntry query = scrapeURL ("https://dictionary.cambridge.org/dictionary/english/" ++ query) scrapeEntry
