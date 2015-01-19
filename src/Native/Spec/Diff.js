Elm.Native.Spec = Elm.Native.Spec || {};
Elm.Native.Spec.Diff = {};
Elm.Native.Spec.Diff.make = function(elm) {
  elm.Native = elm.Native || {};
  elm.Native.Spec = elm.Native.Spec || {};
  elm.Native.Spec.Diff = elm.Native.Spec.Diff || {};
  if (elm.Native.Spec.Diff.values) return elm.Native.Spec.Diff.values;

  // node.js dependencies
  var formatter = require('unfunk-diff');

  // Imports
  var IO = Elm.IO.IO.make(elm);

  function putDiff(a, b) {
    return IO.Impure
      ( IO.PutS
          (formatter.ansi(a,b) + "\n")
          (function() { return IO.pure(null)})
      );
  }

  return elm.Native.Spec.Diff.values = {
    putDiff: F2(putDiff)
  };
};
