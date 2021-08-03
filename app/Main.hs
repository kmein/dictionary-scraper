module Main where

import Control.Applicative
import Data.Aeson
import qualified Data.ByteString.Lazy.Char8 as B
import Data.Char (isSpace)
import GHC.Generics (Generic)
import Text.HTML.Scalpel
import System.Environment

import qualified Cambridge

main :: IO ()
main = do
  query <- head <$> getArgs
  B.putStrLn . encode =<< Cambridge.getEntry query
