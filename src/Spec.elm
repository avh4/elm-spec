module Spec
  ( describe, it
  , passes
  , shouldEqual, shouldEqualString, shouldContain
  , Spec(..)
  , Assertion(..), Failure(..)
  ) where

import List
import String
import Diff (..)

type Spec
  = Group String (List Spec)
  | Test String Assertion

type Failure
  = Message String
  | Diff String (List Change)

type Assertion
  = Pass
  | Fail Failure

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
  | otherwise -> Fail (Message failureMessage)

assertWithDiff : String -> Bool -> String -> String -> Assertion
assertWithDiff failureMessage b ax bx = if
  | b -> Pass
  | otherwise -> Fail (Diff failureMessage (diffChars ax bx))

shouldEqual : a -> a -> Assertion
shouldEqual a b = assertWithDiff
  ("Expected " ++ toString a ++ " to equal " ++ toString b)
  (a == b)
  (toString a)
  (toString b)

shouldEqualString : String -> String -> Assertion
shouldEqualString a b = if
  | a == b -> Pass
  | otherwise -> Fail <|
    Diff
      ("Expected " ++ toString a ++ " to equal " ++ toString b)
      (diffChars a b)

shouldContain : String -> String -> Assertion
shouldContain haystack needle = assert
  ("Expected \"" ++ haystack ++ "\" to contain \"" ++ needle ++ "\"")
  (String.contains needle haystack)
