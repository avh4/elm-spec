module Spec.Runner.Console (run) where

{-| Run a test suite as a command-line script.

# Run
@docs run

-}

import List
import String

import IO.IO (..)

import Spec (..)
import Diff (..)

greenBackground s = "\x1b[42m" ++ s ++ "\x1b[0m"
redBackground s = "\x1b[41m" ++ s ++ "\x1b[0m"

colorLines fn s = String.join "\n" (List.map fn (String.split "\n" s))

changeToString c = case c of
  NoChange s -> s
  Added s -> colorLines greenBackground s
  Removed s -> colorLines redBackground s
  Changed a b -> (colorLines greenBackground a) ++ (colorLines redBackground b)

legend = (greenBackground "+ expected") ++ " " ++ (redBackground "- actual") ++ "\n\n"

changesToString : List Change -> String
changesToString changes = String.join "" (List.map changeToString changes)

print : String -> Spec -> IO ()
print indent spec = case spec of
  Group name children -> List.foldl (\s io -> io >>> print (indent ++ "  ") s) (putStrLn (indent ++ "+ " ++ name)) children
  Test name Pass -> putStrLn <| indent ++ "- " ++ name
  Test name (Fail (Message m)) -> putStrLn <| indent ++ "X " ++ name ++ ": " ++ m
  Test name (Fail (Diff m d)) -> putStrLn <| indent ++ "X " ++ name ++ ": " ++ m ++ "\n\n" ++ legend ++ changesToString d ++ "\n"

exit' : Spec -> IO ()
exit' spec = case passes spec of
  True -> exit 0
  False -> exit 1

run : Spec -> IO ()
run spec = print "  " spec >>> exit' spec
