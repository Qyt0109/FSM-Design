# FSM DESIGN - AUTHOR: [QUYET DAO](https://github.com/Qyt0109)

---

[>>> HOME](../README.md)

[>>> Introduction & more](Intro.md)

[>>> FSM coding style](FSM.md)

[>>> FSM coding examples](Code.md)

---

## 1. Introduction

This repository covers four of the seven commonly taught FSM (Finite State Machine) design techniques. The selected techniques are highlighted below:

- [x] **2 Always Block Coding Style** with combinatorial outputs
- [x] **1 Always Block Coding Style** with registered outputs
- [x] **3 Always Block Coding Style** with registered outputs
- [x] **4 Always Block Coding Style** with registered outputs (new style, not previously shown)
- [ ] Indexed One-Hot Coding Style with registered outputs
- [ ] Parameter One-Hot Coding Style with registered outputs
- [ ] Output Encoded Coding Style with registered outputs

Registering module outputs is typically recommended by synthesis tool vendors, as it helps achieve timing goals more consistently without requiring numerous input and output timing constraints. Registered outputs are also glitch-free, ensuring stable and reliable operation.

## 2. Important design goals

### 2.1. Reduce debugging time by following RTL coding guidelines

Industry trend studies conducted by a leading research group have shown consistent design and verification trends for ASIC and FPGA projects since 2010. Seminars held worldwide in 2010 highlighted that the primary factor causing projects to fall behind schedule was the time spent on debugging.

Research studies from 2010, 2012, 2014, 2016, and 2018 have consistently confirmed that debugging consumes the most significant amount of verification engineering time. Since 2014, debugging has required approximately 95% more effort on average than any other verification task.

These findings make it clear that any coding practices that can reduce debug time are valuable to adopt. The RTL coding guidelines presented in this repository aim to help reduce debug time and increase project efficiency.

### 2.2. MORE LINES OF CODE = MORE BUGS!!!

It's often suggested that more lines of code lead to more bugs. For this reason, I believe concise coding styles that adhere to defensive coding principles—either to avoid bugs or to enable their early detection—are highly valuable, particularly in RTL design and FSM design. In this repository, I highlight where concise coding styles are used and how certain practices help make bugs easier to identify.

## 3. Evaluation Criteria

To determine what makes a good coding style, we have selected the following goals to evaluate different FSM (Finite State Machine) coding styles:

1. The FSM coding style should be easily modifiable, allowing for changes in state encodings and FSM structures.
1. The coding style should be concise.
1. The coding style should be straightforward to write and understand.
1. The coding style should facilitate debugging.
1. The coding style should yield efficient synthesis results.
1. The coding style should support easy modifications to the FSM, including adjustments to the number of inputs and outputs.

Each coding style is assessed based on these criteria, with the results summarized in the table below:

| **Goals**                               | **2 Always, comb outputs** | **1 Always, reg outputs** | **3 Always, reg outputs** | **4 Always, reg outputs** |
|-----------------------------------------|:---------------------------:|:-------------------------:|:--------------------------:|:--------------------------:|
| Easily modifiable state encodings       |              ✅             |             ✅            |              ✅            |              ✅            |
| Concise                                 |              ❌             |             ✅            |              ✅            |              ✅            |
| Easy to understand                      |              ❌             |             ✅            |              ✅            |              ✅            |
| Facilitates debugging                   |              ✅             |             ✅            |              ✅            |              ✅            |
| Efficient synthesis                     |              ✅             |             ❌            |              ✅            |              ✅            |
| Easily modifiable for FSM changes       |              ❌             |             ✅            |              ✅            |              ✅            |
| Conclusion                              | 🖤🖤🖤❤️❤️❤️ <br> Not generally recommended but useful for simple designs where combinational logic for outputs is manageable | 🖤❤️❤️❤️❤️❤️ <br> Recommended for general use | ❤️❤️❤️❤️❤️❤️ <br> Efficient for FSMs with many states and transitions; however, the 4 Always, reg outputs is often preferable | ❤️❤️❤️❤️❤️❤️ <br> Initially complex but ideal for large-scale FSMs; may be overkill for smaller FSMs |
*Summary of Coding Goals*

---

[>>> HOME](../README.md)

[>>> Introduction & more](Intro.md)

[>>> FSM coding style](FSM.md)

[>>> FSM coding examples](Code.md)

---