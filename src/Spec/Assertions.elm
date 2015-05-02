module Spec.Assertions
  ( shouldFail, shouldFailWithMessage
  ) where

{-| Assertions for testing assertions.  These functions are used for testing the `Spec`
package itself.  You probably will not need these unless you are writing custom
assertions and want to write unit tests for your assertion functions.

# Asserting failure
@docs shouldFail, shouldFailWithMessage

-}

import Spec exposing (..)
import Diff exposing (..)

shouldFail : Spec -> Spec
shouldFail a = case a of
  Pass -> Fail (Message "Expected failure")
  Fail _ -> Pass

messageOf : Failure -> String
messageOf f = case f of
  Message m -> m
  Diff m _ -> m

assertWithDiff : String -> Bool -> String -> String -> Spec
assertWithDiff failureMessage b ax bx = if
  | b -> Pass
  | otherwise -> Fail (Diff failureMessage (diffChars ax bx))

shouldFailWithMessage : String -> Spec -> Spec
shouldFailWithMessage expectedMessage a = case a of
  Pass -> Fail (Message "Expected failure")
  Fail m -> assertWithDiff
    ("Expected " ++ toString a ++ " to be a failure with message \""
      ++ expectedMessage ++ "\"")
    ((messageOf m) == expectedMessage)
    (expectedMessage) (messageOf m)
