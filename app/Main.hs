module Main where

import           Example (myApp)
import Network.Wai.Handler.Warp (run)

main :: IO ()
main = run 8080 myApp
