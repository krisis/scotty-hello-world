{-# LANGUAGE OverloadedStrings, QuasiQuotes, TemplateHaskell #-}
module Example (myApp) where

import           Data.Aeson (Value(..), object, (.=))
import           Network.Wai (Application)
import qualified Web.Scotty as S

import Static
import Network.Wai (Application, pathInfo)
import Network.Wai.Application.Static (staticApp)
import WaiAppStatic.Storage.Embedded

app' :: S.ScottyM ()
app' = do
  S.get "/api/some-json" $ do
    S.json $ object ["foo" .= Number 23, "bar" .= Number 42]

apiApp :: IO Application
apiApp = S.scottyApp app'

staticSite :: Application
staticSite = staticApp $(mkSettings mkEmbedded)

-- Application composed of a static embedded site and an API server
myApp :: Application
myApp req handler = do
        let (first : resources) = pathInfo req
        case first of
                "api" -> do
                        api <- apiApp
                        api req handler
                _ -> do
                        staticSite req handler
