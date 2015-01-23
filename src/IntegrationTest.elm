module IntegrationTest where

import IO.IO (..)

import Spec (..)
import Spec.Assertions (..)
import Spec.Runner.Console as Console

import Maybe

type TestType
  = Foo { x: Int }
  | Bar (Maybe String)

tests = describe "Spec"
  [ describe "shouldContain" <|
    [ it "passes when substring is present" <|
      "Principal" `shouldContain` "pal"
    , it "fails when substring is not present" <|
      shouldFail ("Principle" `shouldContain` "pal")
    , it "provides failure message" <|
      ("Principle" `shouldContain` "pal")
      `shouldFailWithMessage`
      "Expected \"Principle\" to contain \"pal\""
    ]
  , describe "shouldEqual" <|
    [ it "passes when equal" <|
      3 `shouldEqual` 3
    , it "fails when not equal" <|
      shouldFail (2 `shouldEqual` 3)
    , it "provides failure message" <|
      (2 `shouldEqual` 3)
      `shouldFailWithMessage`
      "Expected 2 to equal 3"
    , it "compares Elm objects" <|
      (Foo {x=1} `shouldEqual` Bar (Just "hi"))
      `shouldFailWithMessage`
      "Expected Foo { x = 1 } to equal Bar (Just \"hi\")"
    ]
  ]

run : IO ()
run = Console.run tests
