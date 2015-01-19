module Main where

import IO.IO (..)
import IO.Runner (Request, Response, run)

import IntegrationTest

testRunner : IO ()
testRunner = IntegrationTest.run

port requests : Signal Request
port requests = run responses testRunner

port responses : Signal Response
