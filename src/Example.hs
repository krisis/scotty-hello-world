{-# LANGUAGE OverloadedStrings, QuasiQuotes, TemplateHaskell #-}
module Example (runApp, app, myApp) where

import           Data.Aeson (Value(..), object, (.=))
import           Network.Wai (Application)
import qualified Web.Scotty as S

import Static
import Network.Wai (Application)
import Network.Wai.Application.Static (staticApp)
import WaiAppStatic.Storage.Embedded

app' :: S.ScottyM ()
app' = do
  S.get "/" $ do
    S.text "hello"

  S.get "/some-json" $ do
    S.json $ object ["foo" .= Number 23, "bar" .= Number 42]

app :: IO Application
app = S.scottyApp app'

runApp :: IO ()
runApp = S.scotty 8080 app'

myApp :: Application
myApp = staticApp $(mkSettings mkEmbedded)
