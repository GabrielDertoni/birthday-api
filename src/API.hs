module API where

import Control.Applicative
import GHC.Generics (Generic)
import qualified Data.Aeson as Aeson
import Data.Aeson ((.:))
import qualified Data.Text as Text

import Entities.Date
import Entities.User
import Repositories.DateDTO

deriving instance Generic Date

instance Aeson.FromJSON Date where
  parseJSON (Aeson.String v) = do
      case parseDate $ Text.unpack v of
        Just date -> return date
        Nothing   -> empty
  
  parseJSON _ = empty

instance Aeson.ToJSON Date where
  toJSON date = Aeson.String $ Text.pack $ show date

deriving instance Generic User
deriving instance Aeson.FromJSON User
deriving instance Aeson.ToJSON User