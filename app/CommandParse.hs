module CommandParse
  ( Option(..)
--   , parse
  )
  where

import Data.Maybe (fromMaybe)
import Options.Applicative

-------------------------------TYPES------------------------------------
data Option 
    = FromSource 
    {
         templatePath :: FilePath
       , destination :: Source
    }
    | FromTemplateName
    {
         name :: String
       , templatesSrc :: Source
    }
    deriving (Show)

data Source
  = NoSpec
  | Dir FilePath
  deriving (Show)

