{ name = "podcatcher-backend"
, dependencies =
  [ "aff"
  , "console"
  , "control"
  , "effect"
  , "either"
  , "exceptions"
  , "fetch"
  , "maybe"
  , "partial"
  , "prelude"
  , "transformers"
  , "web-dom"
  , "web-dom-parser"
  ]
, packages = ./packages.dhall
, sources = [ "backend/**/*.purs" ]
}
