module Spec
    exposing
        ( describe
        , it
        , passes
        , shouldEqual
        , shouldEqualString
        , shouldContain
        , Spec(..)
        , Failure(..)
        )

{-| Functions for writing simple unit tests.

# Defining specs
@docs describe, it, passes, shouldEqual, shouldEqualString, shouldContain

@docs Spec, Failure

-}

import List
import String
import Diff exposing (..)


{-| Type describing a test case or group of test cases, and more specifically
    their pass/fail status.
-}
type Spec
    = Group String (List Spec)
    | Pass
    | Fail Failure


{-| Type representing a failed state and information to diagnose the failure.
-}
type Failure
    = Message String
    | Diff String (List Change)


{-| Designate a group of test cases.
-}
describe : String -> List Spec -> Spec
describe =
    Group


{-| Another way to designate a group of test cases; usually used when nesting
    a subgroup inside a `describe`, to read more idiomatically.
-}
it : String -> List Spec -> Spec
it =
    describe


{-| Determine whether a spec or group of specs have passed.
-}
passes : Spec -> Bool
passes spec =
    case spec of
        Group _ children ->
            List.all passes children

        Pass ->
            True

        Fail _ ->
            False


assert : String -> Bool -> Spec
assert failureMessage b =
    if b then
        Pass
    else
        Fail (Message failureMessage)


assertWithDiff : String -> Bool -> String -> String -> Spec
assertWithDiff failureMessage b ax bx =
    if b then
        Pass
    else
        Fail (Diff failureMessage (diffChars ax bx))


{-| Asserts that two values are equal
-}
shouldEqual : a -> a -> Spec
shouldEqual b a =
    assertWithDiff ("Expected " ++ toString a ++ " to equal " ++ toString b)
        (a == b)
        (toString a)
        (toString b)


{-| Asserts that two `String` values are equal.
-}
shouldEqualString : String -> String -> Spec
shouldEqualString b a =
    if a == b then
        Pass
    else
        Fail
            <| Diff ("Expected " ++ toString a ++ " to equal " ++ toString b)
                (diffChars a b)


{-| Asserts that one `String` contains another.
-}
shouldContain : String -> String -> Spec
shouldContain needle haystack =
    assert ("Expected \"" ++ haystack ++ "\" to contain \"" ++ needle ++ "\"")
        (String.contains needle haystack)
