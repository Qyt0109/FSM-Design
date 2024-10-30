/*
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



    inputs────┐                                        
              │                                        
              ▼ comb           seq          comb       
          ┌───────┐     ┌───────┐     ┌───────┐        
          │ Next  │     │  FSM  │     │Outputs│        
     state│ state │next │ state │state│ logic │outputs 
       ┌─▶│ logic ├────▶│       ├─●──▶│       ├────▶   
       │  └───────┘     └───────┘ │   └───────┘        
       └──────────────────────────┘                    
*/

module fsm_2_always (
    output reg rd,
    output reg ds,

    input clk,
    input rst,

    input start,
    input ws
);

  localparam IDLE = 0;
  localparam READ = 1;
  localparam DLY = 2;
  localparam DONE = 3;

  localparam UNKW = 'x;

  reg [1:0] cstate;
  reg [1:0] nstate;

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
