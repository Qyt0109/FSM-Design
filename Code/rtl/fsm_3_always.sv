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


                              comb             seq       
                        ┌───────┐       ┌───────┐        
                        │ Next  │next   │Outputs│        
                   next │outputs│outputs│  FF   │outputs 
    inputs────┐     ┌──▶│ logic ├──────▶│       ├────▶   
              │     │   └───────┘       └───────┘        
              ▼ comb│          seq                       
          ┌───────┐ │   ┌───────┐                        
          │ Next  │ │   │  FSM  │                        
     state│ state │ │   │ state │state                   
       ┌─▶│ logic ├─●──▶│  FF   ├─┐                      
       │  └───────┘next └───────┘ │                      
       └──────────────────────────┘                      
*/

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
