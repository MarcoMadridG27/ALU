# 🧮 Proyecto FPU – Datapath y Control en Verilog

Este proyecto implementa una **unidad de procesamiento en punto flotante (FPU)** con soporte para operaciones **FP32 y FP16**, integrando control secuencial, datapath, y visualización en displays de 7 segmentos.  
La arquitectura está pensada para funcionar en una **placa Basys3**, y combina módulos de control (`mainfsm`), cómputo (`datapath` y `fpu_unit`) y salida visual (`hex_display`).

---

## ⚙️ Diagrama de Arquitectura

```mermaid
flowchart LR
    classDef top fill:#007ACC,stroke:#003366,stroke-width:2px,color:white;
    classDef control fill:#A45EE5,stroke:#502875,stroke-width:2px,color:white;
    classDef datapath fill:#00BFA6,stroke:#006F58,stroke-width:2px,color:white;
    classDef fpu fill:#FFB84D,stroke:#B36B00,stroke-width:2px,color:black;
    classDef calc fill:#FF6B6B,stroke:#8B0000,stroke-width:2px,color:white;
    classDef display fill:#4FC3F7,stroke:#01579B,stroke-width:2px,color:black;

    subgraph G1["Nivel 1: Top (Integración principal)"]
        TOP["top"]:::top
        CLKDIV["clockdivider2_logic"]:::top
        INSTANCE_TOP["instance_top"]:::top
        DISPLAY["hex_display"]:::display
    end

    subgraph G2["Nivel 2: Control y Datapath"]
        FSM["mainfsm"]:::control
        DATAPATH["datapath"]:::datapath
    end

    subgraph G3["Nivel 3: Unidad FPU"]
        FPU_UNIT["fpu_unit"]:::fpu
        FPU_NEW["fpu_new"]:::fpu
    end

    subgraph G4["Nivel 4: Núcleos de Cálculo"]
        FP32_NEW["fp32_new"]:::calc
        FP16_NEW["fp16_new"]:::calc
        FP_CORE32["fp_core32"]:::calc
        FP_ADD["fp_addsub_rne"]:::calc
        FP_MUL["fp_mul_rne"]:::calc
        FP_DIV["fp_div_rne"]:::calc
    end

    subgraph G5["Nivel 5: Visualización"]
        CLOCK_DIVIDER2["clock_divider2"]:::display
        DISPLAYMUX["DisplayMultiplexer"]:::display
        HEXTO7["HexTo7Segment"]:::display
    end

    TOP --> CLKDIV
    TOP --> INSTANCE_TOP
    TOP --> DISPLAY
    INSTANCE_TOP --> FSM
    INSTANCE_TOP --> DATAPATH
    FSM --> DATAPATH
    DATAPATH --> FPU_UNIT
    FPU_UNIT --> FPU_NEW
    FPU_NEW --> FP32_NEW
    FPU_NEW --> FP16_NEW
    FP32_NEW --> FP_CORE32
    FP_CORE32 --> FP_ADD
    FP_CORE32 --> FP_MUL
    FP_CORE32 --> FP_DIV
    DISPLAY --> CLOCK_DIVIDER2
    DISPLAY --> DISPLAYMUX
    DISPLAYMUX --> HEXTO7

    DATAPATH -.-> INSTANCE_TOP
    INSTANCE_TOP -.-> TOP
    FPU_UNIT -.-> DATAPATH
```

---

## 🔁 Flujo General del Sistema

1. **Entrada (`entry`)**: el usuario introduce el dato u operación a ejecutar.  
2. **FSM (`mainfsm`)**: interpreta el opcode y genera las señales de control (habilitación, selección de resultado, etc.).  
3. **Datapath (`datapath`)**: enruta los operandos, registra los valores intermedios y activa la **FPU**.  
4. **Unidad FPU (`fpu_unit` / `fpu_new`)**: selecciona entre precisión **FP16 o FP32**, y ejecuta la operación indicada (add, sub, mul o div).  
5. **Salida (`hex_display`)**: muestra el resultado final en los **4 displays de 7 segmentos**, actualizando cada dígito mediante multiplexado.

---

## 🧩 Componentes Principales

| Nivel | Módulo | Descripción breve |
|-------|---------|-------------------|
| 🏗️ Nivel 1 | **top** | Integra reloj, núcleo de cómputo y display. |
| 🧠 Nivel 2 | **mainfsm** | Controla el flujo de estados y señales de habilitación. |
| 🔧 Nivel 2 | **datapath** | Maneja registros, multiplexores y conexión a la FPU. |
| 🔬 Nivel 3 | **fpu_unit** | Decodifica el opcode y selecciona precisión FP16/FP32. |
| ⚙️ Nivel 4 | **fpu_new** | Encapsula los módulos `fp32_new` y `fp16_new`. |
| 💡 Nivel 5 | **hex_display** | Controla el reloj lento y muestra resultados en 7 segmentos. |


