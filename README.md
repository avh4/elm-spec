Experimental alternative for writing unit tests

```elm
module Main where

import IO.IO exposing (..)
import IO.Runner exposing (Request, Response, run)

import Spec.Runner.Console as Console
import Spec exposing (..)

allTests = "Example"
  [ describe "Subexample"
    [ (1+1) `shouldEqual` 2
    ]
  ]

testRunner : IO ()
testRunner = Console.run allTests

port requests : Signal Request
port requests = run responses testRunner

port responses : Signal Response
```
