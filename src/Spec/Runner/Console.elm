module Spec.Runner.Console (run) where

{-| Run a test suite as a command-line script.

# Run
@docs run

-}

import List
import String

import IO.IO (..)

import Spec (..)

print : String -> Spec -> IO ()
print indent spec = case spec of
  Group name children -> List.foldl (\s io -> io >>> print (indent ++ "  ") s) (putStrLn (indent ++ "+ " ++ name)) children
  Test name Pass -> putStrLn <| indent ++ "- " ++ name
  Test name (Fail message) -> putStrLn <| indent ++ "X " ++ name ++ ": " ++ message

exit' : Spec -> IO ()
exit' spec = case passes spec of
  True -> exit 0
  False -> exit 1

run : Spec -> IO ()
run spec = print "  " spec >>> exit' spec
