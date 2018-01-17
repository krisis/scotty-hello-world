{-# LANGUAGE TemplateHaskell, QuasiQuotes, OverloadedStrings #-}
module Static (mkEmbedded) where

import WaiAppStatic.Storage.Embedded
import Crypto.Hash.MD5 (hashlazy)
import qualified Data.ByteString.Lazy as BL
import qualified Data.ByteString.Base64 as B64
import qualified Data.Text as T
import qualified Data.Text.Encoding as T

hash :: BL.ByteString -> T.Text
hash = T.take 8 . T.decodeUtf8 . B64.encode . hashlazy

mkEmbedded :: IO [EmbeddableEntry]
mkEmbedded = do
    cssFile <- BL.readFile "browser-app/build/static/css/main.c17080f1.css"
    let cssEmb = EmbeddableEntry {
                  eLocation = "static/css/main.c17080f1.css"
                , eMimeType = "text/css"
                , eContent  = Left (hash cssFile, cssFile)
                }
    jsFile <- BL.readFile "browser-app/build/static/js/main.ee7b2412.js"
    let jsEmb = EmbeddableEntry {
                  eLocation = "static/js/main.ee7b2412.js"
                , eMimeType = "text/javascript"
                , eContent  = Left (hash jsFile, jsFile)
                }
    imgFile <- BL.readFile "browser-app/build/static/media/logo.5d5d9eef.svg"
    let imgEmb = EmbeddableEntry {
                  eLocation = "static/media/logo.5d5d9eef.svg"
                , eMimeType = "img/svg"
                , eContent  = Left (hash imgFile, imgFile)
                }
    htmlFile <- BL.readFile "browser-app/build/index.html"
    let htmlEmb = EmbeddableEntry {
                  eLocation = "index.html"
                , eMimeType = "text/html"
                , eContent  = Left (hash htmlFile, htmlFile)
                }

    
    --let reload = EmbeddableEntry {
    --                eLocation = "anotherdir/test2.txt"
    --               , eMimeType = "text/plain"
    --               , eContent  = Right [| BL.readFile "test2.txt" >>= \c -> return (hash c, c) |]
                   -- }

    return [cssEmb, jsEmb, imgEmb, htmlEmb]
