module API.RegisterUser (registerUserHandler) where

-- External modules
import GHC.Generics (Generic)
import Control.Applicative
import qualified Data.Aeson as Aeson
import Data.Aeson ((.:))
import qualified Data.UUID as UUID
import qualified Data.UUID.V4 as UUID
import Zero.Server
-- Project modules
import API
import qualified Entities.Date as Date
import qualified Entities.User as User
import UseCases.RegisterUser
import Repositories.UserRepositoryImplementation (userRepositoryImplementation)

data RegisterUserResponse = RegisterUserResponse { success :: Bool, errors :: String }
    deriving (Eq, Show, Generic, Aeson.FromJSON, Aeson.ToJSON)

data RequestUser = RequestUser { name :: String, birthday :: Date.Date }
    deriving (Eq, Show, Generic, Aeson.FromJSON, Aeson.ToJSON)

reqToUser :: RequestUser -> IO User.User
reqToUser req
    = do uid <- UUID.nextRandom
         return $ User.User { User.name = name req
                            , User.birthday = birthday req
                            , User.uid = UUID.toString uid }

decodeRequestUser :: Request -> Either String RequestUser
decodeRequestUser req = decodeJson $ requestBody req

registerUserCallback :: Request -> IO Response
registerUserCallback req = case decodeRequestUser req of
    Right reqUser -> do user <- reqToUser reqUser
                        registerUser userRepositoryImplementation user
                        return $ jsonResponse $ RegisterUserResponse { success = True, errors = "" }
    
    Left error -> do putStrLn error
                     return $ jsonResponse $ RegisterUserResponse { success = False, errors = error }


registerUserHandler :: Handler
registerUserHandler = effectfulHandler POST "/register-user" registerUserCallback