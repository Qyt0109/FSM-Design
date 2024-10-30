# FSM DESIGN - AUTHOR: [QUYET DAO](https://github.com/Qyt0109)

---

[>>> HOME](../README.md)

[>>> Introduction & more](Intro.md)

[>>> FSM coding style](FSM.md)

[>>> FSM coding examples](Code.md)

---

## Examples:

FSM:

```
                      rst                 
                       │  ┌───┐           
                       │  │   │           
                       ▼  ▼   │start=0    
                  ┌─────────┐ │           
                  │  IDLE   ├─┘           
                  │         │             
         ┌───────▶│  rd=0   ├──────────┐  
         │        │  ds=0   │ start=1  │  
         │        └─────────┘          │  
         │                             │  
         │                             ▼  
    ┌────┴────┐                ┌─────────┐
    │  DONE   │                │  READ   │
    │         │                │         │
    │  rd=0   │                │  rd=1   │
    │  ds=1   │                │  ds=0   │
    └─────────┘                └─┬───────┘
         ▲                       │     ▲  
         │        ┌─────────┐    │     │  
         │        │   DLY   │◀───┘     │  
         │        │         │          │  
         │        │  rd=1   │          │  
         └────────┤  ds=0   ├──────────┘  
            ws=0  └─────────┘  ws=1       
```

Example code for schemes:

- [One Always Block FSM coding style - registered outputs](#one-always-block-fsm-coding-style---registered-outputs)
    - File: [fsm_1_always.sv](../Code/rtl/fsm_1_always.sv)
- [Two Always Block FSM coding style - combinatorial outputs](#two-always-block-fsm-coding-style---combinatorial-outputs)
    - File: [fsm_2_always.sv](../Code/rtl/fsm_2_always.sv)
- [Three Always Block FSM coding style - registered outputs](#three-always-block-fsm-coding-style---registered-outputs)
    - File: [fsm_3_always.sv](../Code/rtl/fsm_3_always.sv)
- [Four Always Block FSM coding style - registered outputs](#four-always-block-fsm-coding-style---registered-outputs)
    - File: [fsm_4_always.sv](../Code/rtl/fsm_4_always.sv)

## One Always Block FSM coding style - registered outputs

- File: [fsm_1_always.sv](../Code/rtl/fsm_1_always.sv)

``` verilog
module fsm_1_always (
    output reg rd,
    output reg ds,

    input clk,
    input rst,

    input start,
    input ws
);

  localparam IDLE = "IDLE";
  localparam READ = "READ";
  localparam DLY = "DLY";
  localparam DONE = "DONE";

  localparam UNKW = 'x;

  reg [4*8-1:0] cstate;

  always_ff @(posedge clk, posedge rst) begin
    if (rst) begin
      cstate <= IDLE;
      rd     <= 0;
      ds     <= 0;
    end else begin
      cstate <= UNKW;  // Need @LB
      rd <= 0;
      ds <= 0;
      case (cstate)
        IDLE:
        if (start) begin
          cstate <= READ;
          rd     <= 1;
        end else cstate <= IDLE;  // @LB
        READ: begin
          cstate <= DLY;
          rd     <= 1;
        end
        DLY:
        if (ws) begin
          cstate <= READ;
          rd     <= 1;
        end else begin
          cstate <= DONE;
          ds     <= 1;
        end
        DONE: cstate <= IDLE;
        default: begin
          cstate <= UNKW;
          rd     <= UNKW;
          ds     <= UNKW;
        end
      endcase
    end
  end

endmodule
```

## Two Always Block FSM coding style - combinatorial outputs

- File: [fsm_2_always.sv](../Code/rtl/fsm_2_always.sv)

``` verilog
module fsm_2_always (
    output reg rd,
    output reg ds,

    input clk,
    input rst,

    input start,
    input ws
);

  localparam IDLE = "IDLE";
  localparam READ = "READ";
  localparam DLY = "DLY";
  localparam DONE = "DONE";

  localparam UNKW = 'x;

  reg [4*8-1:0] cstate;
  reg [4*8-1:0] nstate;

  always_ff @(posedge clk, posedge rst)
    if (rst) cstate <= IDLE;
    else cstate <= nstate;

  // /*
  always_comb begin
    nstate = UNKW;  // Need @LB
    rd = 0;
    ds = 0;
    case (cstate)
      IDLE: nstate = start ? READ : IDLE;
      READ: begin
        nstate = DLY;
        rd     = 1;
      end
      DLY: begin
        nstate = ws ? READ : DONE;
        rd     = 1;
      end
      DONE: begin
        nstate = IDLE;
        ds     = 1;
      end
      default: begin
        nstate = UNKW;
        rd     = UNKW;
        ds     = UNKW;
      end
    endcase
  end
  // */

  /*
  // For added flexibility, outputs can optionally be moved out of the main `always_comb` block
  // and placed in a separate `always_comb` block or defined through continuous assignment statements.
  // This modular approach helps in managing and organizing the next-state and output logic distinctly.

  always_comb begin
    nstate = UNKW;  // @LB nstate = cstate;
    case (cstate)
      IDLE:    nstate = start ? READ : IDLE;
      READ:    nstate = DLY;
      DLY:     nstate = ws ? READ : DONE;
      DONE:    nstate = IDLE;
      default: nstate = UNKW;
    endcase
  end

  always_comb begin
    rd = 0;
    ds = 0;
    case (cstate)
      READ:    rd = 1;
      DLY:     rd = 1;
      DONE:    ds = 1;
      default: {rd, ds} = UNKW;
    endcase
  end
  // */

endmodule
```

## Three Always Block FSM coding style - registered outputs

- File: [fsm_3_always.sv](../Code/rtl/fsm_3_always.sv)

``` verilog
module fsm_3_always (
    output reg rd,
    output reg ds,

    input clk,
    input rst,

    input start,
    input ws
);

  localparam IDLE = "IDLE";
  localparam READ = "READ";
  localparam DLY = "DLY";
  localparam DONE = "DONE";

  localparam UNKW = 'x;

  reg [4*8-1:0] cstate;
  reg [4*8-1:0] nstate;

  always_ff @(posedge clk, posedge rst)
    if (rst) cstate <= IDLE;
    else cstate <= nstate;

  always_comb begin
    nstate = UNKW;  // @LB nstate = cstate;
    case (cstate)
      IDLE:    nstate = start ? READ : IDLE;
      READ:    nstate = DLY;
      DLY:     nstate = ws ? READ : DONE;
      DONE:    nstate = IDLE;
      default: nstate = UNKW;
    endcase
  end

  always_ff @(posedge clk, posedge rst) begin
    if (rst) begin
      rd <= 0;
      ds <= 0;
    end else begin
      rd <= 0;
      ds <= 0;
      case (nstate)
        IDLE:    ;
        READ:    rd <= 1;
        DLY:     rd <= 1;
        DONE:    ds <= 1;
        default: {rd, ds} <= UNKW;
      endcase
    end
  end

endmodule
```

## Four Always Block FSM coding style - registered outputs

- File: [fsm_4_always.sv](../Code/rtl/fsm_4_always.sv)

``` verilog
module fsm_4_always (
    output reg rd,
    output reg ds,

    input clk,
    input rst,

    input start,
    input ws
);

  localparam IDLE = "IDLE";
  localparam READ = "READ";
  localparam DLY =  "DLY";
  localparam DONE = "DONE";

  localparam UNKW = 'x;

  reg [4*8-1:0] cstate;
  reg [4*8-1:0] nstate;

  always_ff @(posedge clk, posedge rst)
    if (rst) cstate <= IDLE;
    else cstate <= nstate;

  always_comb begin
    nstate = UNKW;  // @LB nstate = cstate;
    case (cstate)
      IDLE:    nstate = start ? READ : IDLE;
      READ:    nstate = DLY;
      DLY:     nstate = ws ? READ : DONE;
      DONE:    nstate = IDLE;
      default: nstate = UNKW;
    endcase
  end

  reg nrd;  // next rd
  reg nds;  // next ds

  always_comb begin
    nrd = 0;
    nds = 0;
    case (cstate)
      IDLE:    if(start) nrd = 1;
      READ:    nrd = 1;
      DLY: begin
        if (ws) nrd = 1;
        else nds = 1;
      end
      DONE: ;
      default: {nrd, nds} = UNKW;
    endcase
  end

  always_ff @(posedge clk, posedge rst) begin
    if (rst) begin
      rd <= 0;
      ds <= 0;
    end else begin
      rd <= nrd;
      ds <= nds;
    end
  end

endmodule
```

---

[>>> HOME](../README.md)

[>>> Introduction & more](Intro.md)

[>>> FSM coding style](FSM.md)

[>>> FSM coding examples](Code.md)

---