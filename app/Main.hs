module Main where

import qualified Data.ByteString.Lazy.Char8 as B
import Options.Applicative
import Data.Aeson (encode)

import qualified Cambridge

data Options = Options { backend :: Backend, query :: String }

data Backend = Cambridge

main :: IO ()
main = do
  opts <- execParser optsParser
  case backend opts of
    Cambridge -> B.putStrLn . encode =<< Cambridge.getEntry (query opts)
  where
    optsParser :: ParserInfo Options
    optsParser =
        info (helper <*> programOptions) (fullDesc <> progDesc "dics" <> header "a dictionary scraper")
    programOptions :: Parser Options
    programOptions =
        Options <$> backendOption <*> strArgument (metavar "QUERY" <> help "Query string for the dictionary")
    backendOption = option (oneOf backends)
          ( long "backend"
          <> metavar "BACKEND"
          <> value Cambridge
          <> help "The dictionary website to query"
          )
    oneOf dic = str >>= \s -> maybe (readerError "Invalid backend.") pure (lookup s dic)
    backends = [(Cambridge.url, Cambridge)]
