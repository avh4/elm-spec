module Spec
  ( describe, it
  , passes
  , shouldEqual, shouldFail, shouldFailWithMessage, shouldContain
  , Spec(..)
  , Assertion(..)
  ) where

import List
import String

type Spec
  = Group String (List Spec)
  | Test String Assertion

type Assertion
  = Pass
  | Fail String

describe : String -> List Spec -> Spec
describe = Group

it : String -> Assertion -> Spec
it = Test

passes : Spec -> Bool
passes spec = case spec of
  Group _ children -> List.all passes children
  Test _ Pass -> True
  Test _ _ -> False

assert : String -> Bool -> Assertion
assert failureMessage b = if
  | b -> Pass
  | otherwise -> Fail failureMessage

shouldEqual : a -> a -> Assertion
shouldEqual a b = assert "not equal" (a == b)

shouldFail : Assertion -> Assertion
shouldFail a = case a of
  Pass -> Fail "Expected failure"
  Fail _ -> Pass

shouldFailWithMessage : Assertion -> String -> Assertion
shouldFailWithMessage a expectedMessage = case a of
  Pass -> Fail "Expected failure"
  Fail m -> assert
    ("Expected " ++ toString a ++ " to be a failure with message \""
      ++ expectedMessage ++ "\"")
    (m == expectedMessage)

shouldContain : String -> String -> Assertion
shouldContain haystack needle = assert
  ("Expected \"" ++ haystack ++ "\" to contain \"" ++ needle ++ "\"")
  (String.contains needle haystack)
