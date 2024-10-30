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


                               seq       
                        ┌───────┐        
                   next │Outputs│        
                outputs │  FF   │outputs 
    inputs────┐     ┌──▶│       ├────▶   
              │     │   └───────┘        
              ▼ comb│                    
          ┌───────┐ │                    
          │       ├─┘          seq       
          │ Next  │     ┌───────┐        
          │ state │     │  FSM  │        
     state│ logic │next │ state │state   
       ┌─▶│       ├────▶│  FF   ├─┐      
       │  └───────┘     └───────┘ │      
       └──────────────────────────┘      
*/

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
