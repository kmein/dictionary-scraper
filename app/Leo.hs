{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}

module Leo where

import Control.Applicative
import Data.Text (Text)
import Text.HTML.Scalpel
import Types
import qualified Data.Text as T (unwords)
import Util

url :: String
url = "dict.leo.org"

scrapeDefinitions :: Scraper Text [Definition]
scrapeDefinitions =
  chroots ("tr" @: ["data-dz-ui" @= "dictentry"]) $ do
    definiendum <- optional $ text' ("td" @: ["lang" @= "en"] // "samp")
    definiens <- optional $ text' ("td" @: ["lang" @= "de"] // "samp")
    let examples = Nothing
        synonyms = Nothing
        level = Nothing
        partOfSpeech = Nothing
        guideWord = Nothing
        usage = Nothing
        grammar = Nothing
        note = Nothing
    return Definition {..}

getDefinitions :: String -> IO (Maybe [Definition])
getDefinitions query = scrapeURL ("https://" ++ url ++ "/german-english/" ++ query) scrapeDefinitions
