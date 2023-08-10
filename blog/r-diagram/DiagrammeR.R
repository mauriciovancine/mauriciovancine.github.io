library(DiagrammeR)
library(DiagrammeRsvg)
library(rsvg)

mermaid("
        graph BT
        A((Salinity))
        A-->B(Barnacles)
        B-.->|-0.10|B1{Mussels}
        A-- 0.30 -->B1

        C[Air Temp]
        C-->B
        C-.->E(Macroalgae)
        E-->B1
        C== 0.89 ==>B1

        style A fill:#FFF, stroke:#333, stroke-width:4px
        style B fill:#9AA, stroke:#9AA, stroke-width:2px
        style B1 fill:#879, stroke:#333, stroke-width:1px
        style C fill:#ADF, stroke:#333, stroke-width:2px
        style E fill:#9C2, stroke:#9C2, stroke-width:2px

        ")
