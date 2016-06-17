#!/bin/sh

# Compile the Elm files, then open the page in Safari.
if elm make --output "elm.js" src/Main.elm ; then
    # open index.html -a Safari
    open index.html -a "Google Chrome"
fi
