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
*/

module test_fsm;

  // Parameters
  localparam CLK_PERIOD = 10;

  // Ports
  wire rd;
  wire ds;
  reg  clk = 0;
  reg  rst = 0;
  reg  start = 0;
  reg  ws = 0;

  fsm_1_always fsm_always_dut (
      .rd(rd),
      .ds(ds),

      .clk(clk),
      .rst(rst),

      .start(start),
      .ws   (ws)
  );

  initial begin
    begin
      $dumpfile("test_fsm.vcd");
      $dumpvars;
      reset(3);
      test();
      nop_clk(3);
      $finish;
    end
  end

  task automatic test;
    begin
      nop_clk(3);
      start = 1;
      @(negedge clk);
      start = 0;

      ws = 1;
      nop_clk(5);
      ws = 0;
    end
  endtask  //automatic

  task automatic reset;
    input integer n;
    rst = 1;
    repeat (n) @(negedge clk);
    rst = 0;
  endtask  //automatic

  task automatic nop_clk;
    input integer n;
    repeat (n) @(negedge clk);
  endtask  //automatic

  always #(CLK_PERIOD / 2) clk = !clk;

endmodule
