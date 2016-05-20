module Spec.Runner.Console exposing (run) 

{-| Run a test suite as a command-line script.

# Run
@docs run

-}

import List
import String

import Spec exposing (..)
import Diff exposing (..)

greenBackground : String -> String
greenBackground s = "\x1b[42m" ++ s ++ "\x1b[0m"

redBackground : String -> String
redBackground s = "\x1b[41m" ++ s ++ "\x1b[0m"

colorLines : (String -> String) -> String -> String
colorLines fn s = String.join "\n" (List.map fn (String.split "\n" s))

changeToString : Change -> String
changeToString c = case c of
  NoChange s -> s
  Added s -> colorLines greenBackground s
  Removed s -> colorLines redBackground s
  Changed a b -> (colorLines greenBackground a) ++ (colorLines redBackground b)

legend : String
legend = (greenBackground "+ expected") ++ " " ++ (redBackground "- actual") ++ "\n\n"

changesToString : List Change -> String
changesToString changes = String.join "" (List.map changeToString changes)

stringify : String -> Spec -> String
stringify indent spec = case spec of
  Pass -> indent ++ "- OKAY" ++ "\n"
  Fail (Message m) -> indent ++ "X " ++ ": " ++ m ++ "\n"
  Fail (Diff m d)  -> indent ++ "X " ++ ": " ++ m ++ "\n\n" ++ legend ++ changesToString d ++ "\n\n"
  Group name children -> List.foldl (\s accum -> accum ++ stringify (indent ++ "  ") s) (indent ++ "+ " ++ name ++ "\n") children
  
exit' : Spec -> String -> String
exit' spec output = case passes spec of
  True -> Debug.log output ""
  False -> Debug.crash output

{-| Turn the pass/fail status of a `Spec` into a `String`, `Debug.log` that 
    result, and exit.
-}
run : Spec -> String
run spec = stringify "  " spec |> exit' spec
