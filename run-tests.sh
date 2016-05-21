#!/bin/bash

set -ex

if [ "$1" == "--clean" ]; then
  rm -Rf elm-stuff/build-artifacts
fi

mkdir -p build
elm-make src/TestRunner.elm --output build/test.js

node build/test.js

set +x
cat <<EOF

  _,  ,_   _, _  ___,    _, ,  ,  _, _, _, _, _,
 / _  |_) /_,'|\' |     (_, |  | /  /  /_,(_,(_,
'\_|\`'| \'\_  |-\ |      _)'\__|'\_'\_'\_  _) _)
  _|  '  \`  \` '  \`'     '      \`   \`  \`  \`'  '
 '

EOF
