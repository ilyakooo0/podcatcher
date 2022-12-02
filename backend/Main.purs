module Main where

import Prelude

import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Data.Podcast (parsePodcast, runParser_)
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Effect.Exception (throw)
import Fetch (Method(..), RequestMode(..), fetch)
import Partial.Unsafe (unsafePartial)
import Web.DOM.DOMParser (makeDOMParser, parseXMLFromString)
import Web.DOM.Document as Document
import Web.DOM.Node as Node

atp = "https://atp.fm/rss"

getAtp = fetch "http://feeds2.feedburner.com/JupiterBroadcasting" { method: GET }

main :: Effect Unit
main = unsafePartial do
  parser <- makeDOMParser
  launchAff_ do

    resp <- getAtp
    liftEffect $ log $ show resp.statusText
    respText <- resp.text
    liftEffect $ log respText
    liftEffect $ parseXMLFromString respText parser >>= case _ of
      Left err -> throw err
      Right doc -> do
        Just el <- Document.documentElement doc
        runParser_ $ parsePodcast el
        pure unit
    pure unit
  log "🍝"
