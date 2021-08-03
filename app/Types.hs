{-# LANGUAGE DeriveGeneric #-}

module Types where

import Data.Aeson
import GHC.Generics (Generic)

data Entry = Entry
  { entry :: String,
    senses :: [Sense]
  }
  deriving (Show, Generic)

instance ToJSON Entry where
  toJSON = genericToJSON defaultOptions {omitNothingFields = True}

data Sense = Sense
  { sense :: Maybe String,
    partOfSpeech :: Maybe String,
    guideWord :: Maybe String,
    note :: Maybe String,
    grammar :: Maybe String,
    usage :: Maybe String,
    level :: Maybe String,
    definition :: Maybe String,
    examples :: Maybe [String],
    synonyms :: Maybe [Synonym]
  }
  deriving (Show, Generic)

instance ToJSON Sense where
  toJSON = genericToJSON defaultOptions {omitNothingFields = True}

data Synonym = Synonym
  { synonym :: String,
    synonymUsage :: Maybe String,
    region :: Maybe String,
    info :: Maybe String
  }
  deriving (Show, Generic)

instance ToJSON Synonym where
  toJSON = genericToJSON defaultOptions {omitNothingFields = True}
