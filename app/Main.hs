module Main where

import qualified Cambridge
import qualified Leo
import Data.Aeson (encode)
import qualified Data.ByteString.Lazy.Char8 as B
import Data.List
import Options.Applicative

data Options = Options {backend :: Backend, query :: String}

data Backend = Cambridge | Leo

main :: IO ()
main = do
  opts <- execParser optsParser
  case backend opts of
    Cambridge -> B.putStrLn . encode =<< Cambridge.getDefinitions (query opts)
    Leo -> B.putStrLn . encode =<< Leo.getDefinitions (query opts)
  where
    optsParser :: ParserInfo Options
    optsParser =
      info (helper <*> programOptions) (fullDesc <> progDesc "dics" <> header "a dictionary scraper")
    programOptions :: Parser Options
    programOptions =
      Options <$> backendOption <*> strArgument (metavar "QUERY" <> help "Query string for the dictionary")
    backendOption =
      option
        (oneOf backends)
        ( long "backend"
            <> metavar "BACKEND"
            <> value (snd $ head backends)
            <> help ("The dictionary website to query: " <> intercalate " | " (map fst backends))
        )
    oneOf dic = str >>= \s -> maybe (readerError "Invalid backend.") pure (lookup s dic)
    backends = [(Cambridge.url, Cambridge), (Leo.url, Leo)]
