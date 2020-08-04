module Interfaces.UserRepository (UserRepository(..)) where

import Control.Concurrent.Async
import Entities.User (User)

class UserRepository a where
  findUserById :: a -> String -> IO (Async (Maybe User))
  saveUser :: a -> User -> IO (Async ())
  getAllUsers :: a -> IO (Async [User])