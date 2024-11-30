library(DiagrammeR)

DiagrammeR::grViz("digraph {

graph [ordering = in, nodesep = 6, ranksep = 8, layout = dot, rankdir = TB]
node [fontcolor = gray35, fontname = Helvetica, shape = rectangle, style = filled, fillcolor = Linen, fontsize = 500]
edge [color = black, arrowhead = vee, arrowsize = 25, penwidth = 15] 

data1 [label = '\n     Ciência     \n ', fillcolor = aliceblue]
data2 [label = '\n Pseudociência \n ', fillcolor = aliceblue]

sci1 [label = '\n     Boa     \n ', fillcolor = aliceblue]
sci2 [label = '\n     Ruim     \n ', fillcolor = aliceblue]

obs1 [label = '\n Observação \n ', shape = ellipse]
obs2 [label = '\n Observação \n ', shape = ellipse]
obs3 [label = '\n Observação \n ', shape = ellipse]

h1 [label = 'Hipóteses \n com \n fortes premissas', shape = ellipse]
h2 [label = 'Hipóteses \n com \n fortes premissas', shape = ellipse]
h3 [label = 'Hipóteses com \n premissas fracas \n ou inválidas', shape = ellipse]

exp1 [label = 'Experimentação \n robusta \n ', shape = diamond, fillcolor = Beige]
exp2 [label = 'Experimentação \n malfeita ou \n fraudulenta', shape = diamond, fillcolor = Beige]

teo [label = '\n Teoria \n ', shape = circle, fillcolor = honeydew]

lei1 [label = '\n    Lei     \n ', shape = cylinder, fillcolor = lightcyan]
lei2 [label = '\n    Lei     \n ', shape = cylinder, fillcolor = lightcyan]

# edge definitions with the node IDs
data1 -> sci1 -> obs1 -> h1 -> exp1;
exp1 -> teo [arrowhead = normal, color = red];
exp1 -> teo [dir = back, color = red];

data1 -> sci2 -> obs2 -> h2 -> exp2;
exp2 -> teo [arrowhead = normal, color = red];
exp2 -> teo [dir = back, color = red];

teo -> lei1;

data2 -> obs3 [minlen = 2];
obs3 -> h3;
h3 -> lei2 [minlen = 3];

}")
