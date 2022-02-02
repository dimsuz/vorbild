{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}

module Vorbild.TemplateValue.Config where

import           Control.Exception
import           Data.Aeson
import qualified Data.Map.Strict   as Map
import qualified Data.Text         as T
import qualified Data.Text.IO      as T
import           GHC.Generics

data ValueConfigItem =
  ValueConfigItem
    { name  :: ValueName
    , label :: Maybe T.Text
    , value :: Maybe RawValue
    }
  deriving (Generic, Show)

instance FromJSON ValueConfigItem

instance ToJSON ValueConfigItem

type ValueName = T.Text

type RawValue = T.Text

readAndParseConfigItemsFromJson :: FilePath -> IO [ValueConfigItem]
readAndParseConfigItemsFromJson path = do
  fields <- eitherDecodeFileStrict path :: IO (Either String [ValueConfigItem])
  case fields of
    Left e       -> throwIO (userError e)
    Right result -> pure result

prepareRawValues :: [ValueConfigItem] -> IO (Map.Map ValueName RawValue)
prepareRawValues fields = do
  let transform =
        \field ->
          case (value field) of
            (Just v) -> pure (name field, v)
            Nothing -> do
              let hint =
                    case (label field) of
                      Nothing  -> "Specify: " <> name field
                      Just txt -> txt
              T.putStrLn hint
              input <- T.getLine
              pure (name field, input)
  filledFields <- traverse transform fields
  pure $ Map.fromList filledFields
