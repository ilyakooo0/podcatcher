module Data.Podcast
  ( parsePodcast
  , runParser
  , runParser_
  , Parser
  , Podcast
  ) where

import Prelude

import Control.Monad.Maybe.Trans (MaybeT, runMaybeT)
import Control.Monad.Trans.Class (lift)
import Control.Plus (empty)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Console (log)
import Web.DOM (Element, HTMLCollection)
import Web.DOM.Element as Element
import Web.DOM.HTMLCollection as HTMLCollection
import Web.DOM.Node as Node
import Web.DOM.ParentNode as ParentNode

type Podcast = {}

parsePodcast :: Element -> Parser Podcast
parsePodcast doc = do
  el <- findChild "rss" doc
  logElement el
  pure {}

findChild :: String -> Element -> Parser Element
findChild tag parent = do
  children <- lift $ ParentNode.children $ Element.toParentNode parent
  go 0 children
  where
  go :: Int -> HTMLCollection -> Parser Element
  go n collection =
    lift (HTMLCollection.item n collection) >>= case _ of
      Nothing -> empty
      Just el | Element.tagName el == tag -> pure el
      Just _ -> go (n + 1) collection

logElement :: Element -> Parser Unit
logElement el = lift $ Node.textContent (Element.toNode el) >>= log

type Parser = MaybeT Effect

runParser :: forall a. Parser a -> Effect (Maybe a)
runParser = runMaybeT

runParser_ :: forall a. Parser a -> Effect Unit
runParser_ = void <<< runParser
