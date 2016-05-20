module IntegrationTest exposing (run)

import Spec exposing (..)
import Spec.Assertions exposing (..)
import Spec.Runner.Console as Console

import Maybe

type TestType
  = Foo { x: Int }
  | Bar (Maybe String)

tests = describe "Spec"
  [ describe "shouldContain"
    [ "Principal" |> shouldContain "pal"
    , "Principle" |> shouldContain "pal" |> shouldFail
    , "Principle" |> shouldContain "pal"
      |> shouldFailWithMessage "Expected \"Principle\" to contain \"pal\""
    ]
  , describe "shouldEqual"
    [ 3 |> shouldEqual 3
    , 2 |> shouldEqual 3 |> shouldFail
    , 2 |> shouldEqual 3 |> shouldFailWithMessage "Expected 2 to equal 3"
    , (Foo {x=1}) |> shouldEqual (Bar (Just "hi"))
      |> shouldFailWithMessage "Expected Foo { x = 1 } to equal Bar (Just \"hi\")"
    ]
  ]

run : String
run = Console.run tests
