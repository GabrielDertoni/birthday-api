import Test.Hspec
import Test.QuickCheck
import Control.Exception (evaluate)
import Data.List
import Control.Concurrent.Async

import qualified Entities.Date as Entities
import qualified Entities.User as Entities
import qualified Entities.Birthday as Entities
import qualified UseCases.GetUsers as UseCases
import qualified UseCases.RegisterUser as UseCases
import qualified Interfaces.UserRepository as Interfaces
import qualified Repositories.CSVParser as CSVParser
import qualified Repositories.DateDTO as DateDTO
import qualified Repositories.UserDTO as UserDTO

data MockRepository = MockRepository { users :: [Entities.User] }

instance Interfaces.UserRepository MockRepository where
  findUserById repo id = async $ pure $ find ((== id) . Entities.uid) $ users repo
  getAllUsers = async . pure . users
  saveUser repo user = async $ pure ()


instance Arbitrary Entities.Date where
  arbitrary = do
    day   <- elements [1..31]
    month <- elements [1..12]
    year  <- elements [1900..2100]
    return Entities.Date { Entities.day   = day
                         , Entities.month = month
                         , Entities.year  = year }

instance Arbitrary Entities.User where
  arbitrary = do
    name <- listOf $ elements ['a'..'z']
    uid  <- arbitrary
    date <- arbitrary
    return Entities.User { Entities.name    = name
                         , Entities.uid     = uid
                         , Entities.birthday = date }

getMockRepository :: [Entities.User] -> MockRepository
getMockRepository us = MockRepository { users = us }

main :: IO ()
main = hspec $ do
  describe "UseCases.GetUsers.getUsers" $ do
    it "gets all of the users from the user repository" $ do
      testUsers <- generate $ listOf arbitrary
      result    <- UseCases.getUsers (getMockRepository testUsers)
      result `shouldBe` testUsers
  
  describe "UserCases.RegisterUser.registerUser" $ do
    it "registers the user in the repository" $ do
      testUser <- generate arbitrary
      result <- UseCases.registerUser (getMockRepository []) testUser
      result `shouldBe` ()
  
  describe "Repository.CSVParser.parseCSV" $ do
    let testCSV = "\"47b37938-2928-4027-8892-782c75a51f42\",\"Some ones name\",18/05/2000\n"
    it "can parse csv correcly" $ do
      let parsed = CSVParser.parseCSV testCSV
      parsed `shouldBe` [[CSVParser.CSString "47b37938-2928-4027-8892-782c75a51f42",
                          CSVParser.CSString "Some ones name",
                          CSVParser.CSDate $
                            Entities.Date { Entities.day   = 18
                                          , Entities.month = 5
                                          , Entities.year  = 2000 }]]
    
    it "can be unmade by Repository.UserDTO.getUserCSVRepresentation" $ do
      let parsed = CSVParser.parseCSV testCSV
      let [userFromCSV] = UserDTO.tableToUserList parsed
      let unparsed = UserDTO.getUserCSVRepresentation userFromCSV
      unparsed `shouldBe` testCSV
  
  describe "Repositories.DateDTO.parseDate" $ do
    it "can parse a date correcly" $ do
      date <- generate arbitrary
      let parsed = DateDTO.parseDate $ show date
      parsed `shouldBe` Just date

