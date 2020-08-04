module Repositories.UserDTO where

import Data.Maybe
import Text.Printf

import Entities.Date
import Entities.User
import Repositories.CSVParser

lineToUser :: CSVLine -> Maybe User
lineToUser line = do (CSString uid ) <- getCSVColumn 1 line
                     (CSString name) <- getCSVColumn 2 line
                     (CSDate   date) <- getCSVColumn 3 line
                     return $ User { name = name, uid = uid, birthday = date }

tableToUserList :: CSVTable -> [User]
tableToUserList = catMaybes . map lineToUser

getUserCSVRepresentation :: User -> String
getUserCSVRepresentation user = printf "%s,%s,%s\n" (show $ uid user) (show $ name user) (show $ birthday user)