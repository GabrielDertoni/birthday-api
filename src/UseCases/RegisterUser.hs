module UseCases.RegisterUser where

import Control.Concurrent.Async
import Interfaces.UserRepository
import Entities.User

registerUser :: UserRepository a => a -> User -> IO ()
registerUser repo user
  = do asc <- saveUser repo user
       wait asc
       return ()