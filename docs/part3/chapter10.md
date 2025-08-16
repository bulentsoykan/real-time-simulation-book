# Chapter 10: Hybrid Simulation: Composing Multi-Paradigm Models

!!! quote "Chapter Mission"
    To learn techniques for combining different simulation paradigms to model complex systems that exhibit behaviors at multiple scales and domains.

---

### Learning Objectives

By the end of this chapter, you will be able to:

*   **Identify** system components that require different modeling approaches.
*   **Design and implement** a hybrid model where agents (ABM) operate within a process flow (DES).
*   **Understand** co-simulation standards like the Functional Mock-up Interface (FMI).
*   **Couple** a physics-based component model with a larger system model.

---

## 10.1 Beyond a Single Lens: The Need for Hybrid Models

We have explored four powerful modeling paradigms, each providing a unique lens on the world. But what happens when a system is too complex to be captured by a single worldview?
*   A factory is a **process (DES)**, but its efficiency is driven by the adaptive behavior of its **maintenance crew (ABM)**, and its long-term viability depends on **market dynamics (SD)**.
*   A city's transportation network is a system of **vehicle agents (ABM)**, but the traffic flow on any given highway segment can be modeled as a **continuous flow (Dynamical System)**.

Trying to force a single paradigm onto a multi-faceted problem leads to either a gross oversimplification or a model of monstrous, unmanageable complexity. The solution is **hybrid simulation** (or multi-paradigm modeling): the art and science of building a single, cohesive model by composing sub-models from different paradigms.

For a Digital Twin, this is not just a useful technique; it's often a necessity. A comprehensive twin must capture behavior at all relevant scales, from the physics of a single bearing to the strategic dynamics of the supply chain it belongs to.

## 10.2 Strategies for Combining Paradigms

There are two primary ways to combine different modeling approaches.

### Strategy 1: The Integrated Environment
This approach uses a single simulation tool that natively supports multiple paradigms. The tool provides a unified modeling environment and a single simulation engine that knows how to manage the interactions between, for example, agents and discrete-event process blocks.

*   **How it Works:** The model components can directly call each other and share memory. An agent can be injected into a DES process flow as an entity. A DES block can query the state of a population of agents. The System Dynamics model can read aggregate statistics from the DES model as an input to its flows.
*   **Primary Example:** **AnyLogic** is the leading commercial tool built from the ground up on this principle. It allows you to freely mix DES, ABM, and SD components in the same model.
*   **Pros:** Much easier to build and debug. The tool handles the difficult problems of time synchronization and data exchange internally.
*   **Cons:** Locks you into a specific vendor's ecosystem. May not offer the "best-in-class" tool for every single paradigm.

### Strategy 2: Co-Simulation (Federated Models)
This approach connects multiple, independent, best-in-class simulation tools. Each tool runs its own model in its own environment, and a central "co-simulation master" coordinates the exchange of data and the advancement of time between them.

*   **How it Works:** Imagine a model of an electric car. A detailed battery model is running in a specialized tool like **OpenModelica**. The vehicle dynamics model is running in **Simulink**. The driver's behavior is modeled as an agent in **Python**. The co-simulation master tells each simulator: "Advance your clock to t=0.1s." It then collects the outputs from each (e.g., battery voltage, driver's pedal position), feeds them as inputs to the others, and repeats the cycle.
*   **Primary Standard:** The **Functional Mock-up Interface (FMI)** is the leading industry standard for co-simulation. It defines a common API that allows any compliant simulation tool to be packaged as a "Functional Mock-up Unit" (FMU) that can be imported and controlled by a co-simulation master.
*   **Pros:** Allows you to use the absolute best tool for each part of the problem. Enables collaboration between different teams or even different companies using their preferred tools.
*   **Cons:** Technically much more challenging. Time synchronization and data alignment between simulators are complex and can lead to instability if not managed carefully.

## 10.3 Common Hybrid Patterns

While the possible combinations are endless, a few hybrid patterns are particularly powerful and common in Digital Twin applications.

### Pattern 1: ABM + DES (e.g., Smart Logistics)
This is the classic combination for modeling systems where autonomous agents provide services within a structured process.

*   **Model Structure:** A DES flowchart defines the main process (e.g., `Order Arrival` -> `Queue for Transport` -> `Transport to Destination` -> `Unload`). The `Transport` step, however, is not a simple `delay` block. Instead, it sends a request to a population of `AGV` agents (ABM). An idle agent receives the request, travels to the package, and transports it.
*   **Interaction:** The DES process generates tasks for the ABM agents. The ABM agents act as a shared, intelligent "resource pool" for the DES model.
*   **DT Application:** Twinning a "smart warehouse" where the overall flow of goods is the process, but the execution is carried out by a swarm of autonomous robots.

### Pattern 2: SD + DES/ABM (e.g., Strategic Meets Operational)
This pattern connects a high-level, long-term strategic model with a detailed operational model.

*   **Model Structure:** The SD model simulates the long-term dynamics (e.g., market demand, workforce morale, budget allocation). The outputs of the SD model are fed as parameters into the more detailed DES or ABM model. In turn, the aggregate performance of the operational model can be fed back into the SD model.
*   **Interaction:** The coupling is typically **loose** and happens at different time scales. The SD model might run with a time step of a week, providing a "production target" parameter to the DES factory model. The DES model then runs for a simulated week with a time step of seconds, and its output (`total_parts_produced`) is fed back to the SD model for the next weekly update.
*   **DT Application:** A corporate Digital Twin that links strategic business planning (SD) to the real-time performance of its factory floor (DES), allowing managers to see how high-level policies might impact operational reality.

### Pattern 3: Physics-Based + DES/ABM (e.g., Detailed Component in a Larger System)
This pattern embeds a high-fidelity, physics-based model of a critical component within a larger, more abstract system model.

*   **Model Structure:** A DES model of a production line includes a `Machine` resource. Instead of modeling this machine's processing time with a simple statistical distribution, the processing time is calculated by a detailed, physics-based FMU (co-simulation) of that machine. The FMU might also calculate the `wear` or `stress` on the machine during the operation.
*   **Interaction:** The DES model tells the FMU, "Start processing this part." The FMU runs its detailed physics simulation and, when finished, tells the DES model, "I'm done; the operation took 47.3 seconds and generated 0.012 units of wear." The DES model then uses this information and releases the part.
*   **DT Application:** A Digital Twin of a wind turbine. The overall energy production and control logic might be a system-level model, but the fatigue and stress on a specific gearbox bearing are calculated by a highly detailed, physics-based component twin (FMU).

## 10.4 Challenges in Hybrid Modeling

Creating a robust hybrid model requires careful thought about several technical challenges:

*   **Time Synchronization:** How do we sync an event-based DES model with a time-stepped ABM or continuous model? This is a core problem that co-simulation masters and integrated environments are designed to solve.
*   **Data Exchange:** How do we map the concepts from one paradigm to another? For example, how does an aggregate `Failure Rate` from an SD model translate into discrete breakdown events in a DES model?
*   **Model Coupling (Loose vs. Tight):** How frequently do the sub-models exchange data?
    *   **Loose Coupling:** Infrequent data exchange (e.g., once per simulated day). Computationally cheaper but can miss important fast-acting dynamics.
    *   **Tight Coupling:** Frequent data exchange (e.g., at every time step). More accurate but computationally expensive and can be difficult to stabilize.

---

### Lab Preview: Building a Multi-Paradigm Factory Model

This chapter's lab will be a capstone modeling exercise using **AnyLogic**, which is specifically designed for this kind of hybrid construction. You will model a factory with interacting dynamics at three different scales.

1.  **The Process (DES):** You will start by building a simple DES flowchart for a production process: parts arrive, are processed by a machine, and then depart.
2.  **The Failure Mechanism (SD):** You will then model the machine's health using a System Dynamics stock-and-flow model. A `Machine_Health` stock will be depleted by a `Degradation` flow. When the stock drops below a threshold, the machine in the DES model will fail.
3.  **The Repair Crew (ABM):** When the machine fails, it will signal a need for repair. This signal will be broadcast to a population of `Maintenance_Technician` agents. An available agent will travel to the machine, perform a repair (which restores the `Machine_Health` stock in the SD model), and then return to a waiting area.

This single, integrated model will demonstrate the power of using the right paradigm for the right part of the problem: DES for the workflow, SD for the long-term degradation, and ABM for the intelligent, resource-constrained repair process.