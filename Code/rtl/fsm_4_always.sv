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


    inputs                                       
       │              comb             seq       
       │  inputs┌───────┐       ┌───────┐        
       ●───────▶│ Next  │next   │Outputs│        
       │  state │outputs│outputs│  FF   │outputs 
       │     ┌─▶│ logic ├──────▶│       ├────▶   
       │     │  └───────┘       └───────┘        
       │     │        comb            seq        
       │ inputs ┌───────┐       ┌───────┐        
       └─────┼─▶│ Next  │       │  FSM  │        
          state │ state │ next  │ state │state   
             ●─▶│ logic ├──────▶│  FF   ├─┐      
             │  └───────┘       └───────┘ │      
             └────────────────────────────┘      
*/

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
