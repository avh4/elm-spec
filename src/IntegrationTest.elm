module IntegrationTest where

import IO.IO (..)

import Spec (..)
import Spec.Runner.Console as Console

tests = describe "Spec"
  [ describe "shouldContain" <|
    [ it "passes when substring is present" <|
      "Principal" `shouldContain` "pal"
    , it "fails when substring is not present" <|
      shouldFail ("Principle" `shouldContain` "pal")
    , it "provides failure message" <|
      ("Principle" `shouldContain` "pal") `shouldFailWithMessage` "Expected \"Principle\" to contain \"pal\""
    ]
  ]

run : IO ()
run = Console.run tests
