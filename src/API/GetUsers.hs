module API.GetUsers (getUsersHandler) where

-- External modules
import Zero.Server
-- Project modules
import API
import UseCases.GetUsers
import Repositories.UserRepositoryImplementation

getUsersHandler :: Handler
getUsersHandler = effectfulHandler GET "/list-users" getUsersCallback
    where getUsersCallback :: Request -> IO Response
          getUsersCallback _ = jsonResponse <$> getUsers userRepositoryImplementation