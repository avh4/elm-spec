module Spec.Diff where

import Native.Spec.Diff
import IO.IO (..)

putDiff : a -> a -> IO ()
putDiff = Native.Spec.Diff.putDiff
