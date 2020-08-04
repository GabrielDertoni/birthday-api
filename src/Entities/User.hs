module Entities.User (User(..)) where

import Text.Printf
import Entities.Date (Date)

data User = User { name :: String, uid :: String, birthday :: Date }

instance Show User where
  show user = printf "name: %s\nuid: %s\nbirthday: %s" (name user) (uid user) (show $ birthday user)

instance Eq User where
  (==) userA userB = uid userA == uid userB