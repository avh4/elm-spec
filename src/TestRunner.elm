module Main where

import IO.IO exposing (..)
import IO.Runner exposing (Request, Response, run)

import IntegrationTest

testRunner : IO ()
testRunner = IntegrationTest.run

port requests : Signal Request
port requests = run responses testRunner

port responses : Signal Response
