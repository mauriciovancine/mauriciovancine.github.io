library(DiagrammeR)
library(DiagrammeRsvg)
library(rsvg)

# https://mermaid.js.org/intro/
# https://github.com/fblpalmeira/DiagrammeR/tree/main

DiagrammeR::mermaid("
graph TD
    Start --> Stop
        ")
