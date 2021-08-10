{-# LANGUAGE DeriveGeneric #-}

module Types where

import Data.Aeson
import Data.Text (Text)
import GHC.Generics (Generic)

data Definition = Definition
  { definiendum :: Maybe Text,
    partOfSpeech :: Maybe Text,
    guideWord :: Maybe Text,
    note :: Maybe Text,
    grammar :: Maybe Text,
    usage :: Maybe Text,
    level :: Maybe Text,
    definiens :: Maybe Text,
    examples :: Maybe [Text],
    synonyms :: Maybe [Synonym]
  }
  deriving (Show, Generic)

instance ToJSON Definition where
  toJSON = genericToJSON defaultOptions {omitNothingFields = True}

data Synonym = Synonym
  { synonym :: Text,
    synonymUsage :: Maybe Text,
    region :: Maybe Text,
    info :: Maybe Text
  }
  deriving (Show, Generic)

instance ToJSON Synonym where
  toJSON = genericToJSON defaultOptions {omitNothingFields = True}
