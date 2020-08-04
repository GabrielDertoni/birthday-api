module Repositories.UserRepositoryImplementation (userRepositoryImplementation) where

import Text.Printf
import Data.Maybe
import Data.List
import Control.Concurrent.Async
import Interfaces.UserRepository
import Entities.User
import Entities.Date
import Repositories.UserDTO
import Repositories.CSVParser (parseCSV)


writeUserToFile :: User -> FilePath -> IO ()
writeUserToFile user path
  = appendFile path $ getUserCSVRepresentation user

getUserFromFileById :: String -> FilePath -> IO (Maybe User)
getUserFromFileById id path
  = do users <- readAllUsersFromFile path
       return $ find ((== id) . uid) users

readAllUsersFromFile :: FilePath -> IO [User]
readAllUsersFromFile path = do
  content <- readFile path
  let csv = parseCSV content
  return $ tableToUserList csv

data RepositoryCSV = RepositoryCSV { filePath :: String }

instance UserRepository RepositoryCSV where
  findUserById repo id = async $ getUserFromFileById id (filePath repo)
  saveUser repo user = async $ writeUserToFile user (filePath repo)
  getAllUsers repo = async $ readAllUsersFromFile $ filePath repo

userRepositoryImplementation = RepositoryCSV { filePath = "./database.csv" }
