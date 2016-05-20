#!/bin/bash

set -e
set -x

if [ "$1" == "--clean" ]; then
  rm -Rf elm-stuff/build-artifacts
fi

if ! npm list | grep " jsdom@"; then
  npm install jsdom@3
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
