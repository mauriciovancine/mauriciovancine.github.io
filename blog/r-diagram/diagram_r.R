library(DiagrammeR)
library(DiagrammeRsvg)
library(rsvg)

# https://mermaid.js.org/intro/
# https://github.com/fblpalmeira/DiagrammeR/tree/main

DiagrammeR::grViz("digraph {

graph [ordering = in, nodesep = 6, ranksep = 8, layout = dot, rankdir = TB]
node [fontcolor = gray35, fontname = Arial, shape = rectangle, style = filled, fillcolor = Linen, fontsize = 400]
edge [color = black, arrowhead = vee, arrowsize = 25, penwidth = 15] 

data1 [label = '\n Presence records \n (Download) \n\n', fillcolor = tomato]
data2 [label = '\n Environmental variables \n (WorldClim - 1970-2000) \n (1 km) \n ', fillcolor = aliceblue]

}")