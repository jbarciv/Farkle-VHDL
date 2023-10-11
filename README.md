# Farkle-VHDL

This project is centered on designing and testing a circuit using **Xilinx Vivado** and **VHDL**. The main objective is to build a working circuit that can be simulated and tested on **Pynq boards**. For testing, we'll use the **FPGA Zynq-7020** and an **I/O expansion board** with **LEDs**, **switches**, **buttons**, and **seven-segment displays**. In the final phase, we'll transfer the circuit to a physical Pynq board for hands-on testing in the electronics labs.


Key words:
> FPGA design, programming, physical implementation.

## Content
**[1. Project Description](#1-project-description)**

  * [1.1. Game and Final video](#11-game-and-final-video)
  * [1.2. Code](#12-code)

**[2. Acknowledgments](#2-acknowledgments)**


## 1. Project Description
### 1.1. Game and Final video
The circuit's objective is to replicate the Farkle dice game. The game mechanics are quite straightforward. Players take turns rolling dice, and the score is determined as follows:

- Ones: Each die showing a one is worth 100 points.
- Fives: Each die showing a five is worth 50 points.
- Three identical dice: They are worth the value that repeats, multiplied by 100. For instance, three fours would be worth 400 points. As an exception, if you roll 1-1-1, the score is 1000.
- Four, five, or six identical dice: They are worth 1000, 2000, and 3000 points, respectively, regardless of the die values.


[![IROS 2019: FASTER: Fast and Safe Trajectory Planner for Flights in Unknown Environments](./imgs/farkle.gif)]
(Loading... Please wait)
### 1.2. Code
There are two folders: one containing the code and another with the simulations (*testbenches*). The VHDL code files correspond to hardware description, essentially defining the digital components for building the circuit. Almost all the main blocks have a *top file* (e.g., `top_display.vhd`) that creates instances and establishes connections between the subblocks. The inclusion of state machines endows the files with a form of intelligence that enables a more efficient way of designing. Finally, there is the *main* (`top.vhd`) file that instantiates and interconnects the primary blocks.


## 2. Acknowledgments
First and foremost, I'd like to thank our team members, Estrella, Manuel, and Tomás, for their hard work in getting this project done. They've made everything go smoothly.

I want to express my gratitude to Eduardo de la Torre, Andrés Otero, and Alfonso Rodriguez, who are professors of the Digital Electronics course at [CEI](http://www.cei.upm.es/). Their support and guidance throughout the entire project have been greatly appreciated.


