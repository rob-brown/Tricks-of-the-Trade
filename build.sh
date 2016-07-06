#!/bin/sh

# Compile the Elm files, then open the page in the desired browser.
if elm make --output "elm.js" src/Main.elm ; then
    open index.html -a Safari
    # open index.html -a "Google Chrome"
    # open index.html -a Firefox
fi
