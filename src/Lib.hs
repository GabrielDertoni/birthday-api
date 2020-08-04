module Lib (run) where

import Text.Printf
import Zero.Server
import qualified Data.Aeson as Aeson

import API.GetUsers
import API.RegisterUser

run :: IO ()
run = startServer [
       getUsersHandler
    ,  registerUserHandler
    ]
