module IntegrationTest where

import IO.IO (..)

import Spec (..)
import Spec.Runner.Console as Console

tests = describe "tests"
  [ it "true" <|
    "asd" `shouldContain` "as"
  ]

run : IO ()
run = Console.run tests
