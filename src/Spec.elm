module Spec
  ( describe
  , passes
  , shouldEqual, shouldEqualString, shouldContain
  , Spec(..)
  , Failure(..)
  ) where

import List
import String
import Diff (..)

type Spec
  = Group String (List Spec)
  | Pass
  | Fail Failure

type Failure
  = Message String
  | Diff String (List Change)

describe : String -> List Spec -> Spec
describe = Group

passes : Spec -> Bool
passes spec = case spec of
  Group _ children -> List.all passes children
  Pass -> True
  Fail _ -> False

assert : String -> Bool -> Spec
assert failureMessage b = if
  | b -> Pass
  | otherwise -> Fail (Message failureMessage)

assertWithDiff : String -> Bool -> String -> String -> Spec
assertWithDiff failureMessage b ax bx = if
  | b -> Pass
  | otherwise -> Fail (Diff failureMessage (diffChars ax bx))

shouldEqual : a -> a -> Spec
shouldEqual b a = assertWithDiff
  ("Expected " ++ toString a ++ " to equal " ++ toString b)
  (a == b)
  (toString a)
  (toString b)

shouldEqualString : String -> String -> Spec
shouldEqualString b a = if
  | a == b -> Pass
  | otherwise -> Fail <|
    Diff
      ("Expected " ++ toString a ++ " to equal " ++ toString b)
      (diffChars a b)

shouldContain : String -> String -> Spec
shouldContain needle haystack = assert
  ("Expected \"" ++ haystack ++ "\" to contain \"" ++ needle ++ "\"")
  (String.contains needle haystack)
