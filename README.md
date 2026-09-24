# Queueing System DES Simulator

A MATLAB discrete-event simulator for M/M/1, M/M/1/K, M/G/1, M/D/1, and M/M/m queueing systems with analytical performance validation.

## Overview

This project implements a discrete-event simulation (DES) framework for evaluating the performance of different queueing systems.

Rather than advancing the simulation using fixed time steps, the system is event-driven: the simulation clock advances directly to the next arrival or departure event.

The simulated results are compared with analytical queueing models to validate the implementation.

The main performance metrics are:

- Average number of customers in the system
- Average number of customers waiting in the queue
- Average time spent in the system

## Queueing Models

The simulator supports the following queueing systems:

- **M/M/1** — single server with exponential interarrival and service times
- **M/M/1/K** — single server with finite system capacity
- **M/G/1** — single server with a general service-time distribution
- **M/D/1** — single server with deterministic service time
- **M/M/m** — multiple parallel servers

Different service-time distributions are generated according to the selected queue model.

## Discrete-Event Simulation

The simulation engine maintains the next arrival time and the departure time of each active server.

At each iteration, the simulation clock advances to the earliest scheduled event. The system state is then updated according to whether the event is an arrival or a departure.

The average number of customers in the system is estimated using the time average

$$
\bar{N} = \frac{1}{T}\int_0^T N(t)\,dt
$$

For multi-server systems, the average queue length is similarly estimated as

$$
\bar{N}_Q = \frac{1}{T}\int_0^T \max(0, N(t)-m)\,dt
$$

where \(m\) is the number of servers.

## Analytical Validation

Analytical queueing models are implemented separately from the simulation engine.

Theoretical and simulated results are compared for each queue configuration, allowing the accuracy of the discrete-event simulation to be evaluated quantitatively.

The analytical models include:

- M/M/1 steady-state analysis
- Finite-capacity M/M/1/K analysis
- M/G/1 analysis with uniform service time
- M/D/1 analysis with deterministic service time
- M/M/m multi-server analysis
- Percentage error between analytical and simulated results

## Example Scenario

A multi-server airport service scenario is used to demonstrate the M/M/m model.

Two service classes are considered:

- Business class with 2 servers
- Economy class with 5 servers

Despite having more servers, the economy-class system operates at a higher utilization because of its much larger arrival rate. This results in a longer average queue and a longer average time in the system.

## Project Structure

```text
Queueing-System-DES-Simulator/
├── README.md
├── Main.m
├── simulation.m
└── analysis.m
```

- `Main.m` — defines simulation scenarios, compares theoretical and simulated results, and generates figures
- `simulation.m` — implements the event-driven queueing simulation engine
- `analysis.m` — implements the analytical queueing models

## Results

The discrete-event simulation results closely follow the corresponding analytical results across the tested queueing configurations.

The experiments demonstrate several fundamental queueing effects:

- Finite system capacity can limit queue growth in M/M/1/K systems.
- Service-time variability affects queue length and total time even when the average service rate is similar.
- Multi-server systems become increasingly congested as utilization approaches system capacity.
- Increasing the simulation duration reduces the statistical variation between simulated and analytical results.

## Tools

- MATLAB
- Discrete-Event Simulation
- Queueing Theory
- Stochastic Modelling
- Performance Analysis

## Getting Started

### Requirements

- MATLAB
- Statistics and Machine Learning Toolbox

### Running the Simulation

1. Place `Main.m`, `simulation.m`, and `analysis.m` in the same MATLAB folder.
2. Open the folder in MATLAB.
3. Run `Main.m`.

The program executes the queueing simulations, calculates the corresponding analytical results, reports the percentage errors, and generates comparison figures.
