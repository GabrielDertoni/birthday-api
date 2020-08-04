module UseCases.GetUsers where

import Control.Concurrent.Async
import Interfaces.UserRepository
import Entities.User

getUsers :: UserRepository a => a -> IO [User]
getUsers repo
  = do asc <- getAllUsers repo
       result <- wait asc
       return $ result