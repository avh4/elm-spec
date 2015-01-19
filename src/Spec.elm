module Spec
  ( describe, it
  , passes
  , shouldEqual, shouldContain
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

shouldContain : String -> String -> Assertion
shouldContain haystack needle = assert "doesn't contain" (String.contains needle haystack)
