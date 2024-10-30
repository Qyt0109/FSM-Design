module fsm (
    input  clk, rst,
    output rd,
    ...
);

  reg [BW-1:0] current_state, next_state;

  always_ff @(posedge clk, posedge rst) begin
    if (rst) current_state <= IDLE;       // reset state
    else     current_state <= next_state; // update state
  end

  always_comb begin
    next_state = X; // next state
    rd         = 0; // output
    ...
    case (current_state)
        IDLE: begin
            // logic to change state
            if(start) next_state = READ;
            else      next_state = IDLE;
        end
        READ: begin
            next_state = ...; // logic to change state
            rd         =   1; // output depends on current_state
            ...
        end
        ...
    endcase
  end

endmodule


module fsm (
    input  clk, rst,
    output rd,
    ...
);

  reg [BW-1:0] current_state;

  always_ff @(posedge clk, posedge rst) begin
    if (rst) begin
        current_state <= IDLE;
        outputs       <= 0;
        ...
    end
    else begin    
        current_state <= X;
        outputs       <= 0;
        ...
        case (current_state)
            IDLE: begin
                // logic to change state and next outputs
                if(start) begin
                    current_state <= READ; // next state being registered
                    rd            <= 1;    // next output rd being registered
                    ...
                end else begin
                    current_state <= IDLE;
                end
            end
            READ: begin
                current_state <= ...;
                ...
            end
            ...
        endcase
    end
  end

endmodule


module fsm (
    input  clk, rst,
    output rd,
    ...
);

  reg [BW-1:0] current_state, next_state;

  always_ff @(posedge clk, posedge rst) begin
    if (rst) current_state <= IDLE;       // reset state
    else     current_state <= next_state; // update state
  end

  always_comb begin
    next_state = X; // next state
    case (current_state)
        IDLE: begin
            // logic to change state
            if(start) next_state = READ;
            else      next_state = IDLE;
        end
        READ: begin
            next_state = ...; // logic to change state
        end
        ...
    endcase
  end

  always_ff @(posedge clk, posedge rst) begin
    if (rst) begin
        rd      <= 0; // reset rd output
        outputs <= 0; // reset outputs
        ...
    end
    else begin
        outputs <= 0;
        ...
        case (next_state)
            READ: begin
                rd <= 1; // if next_state is READ, rd will be 1 the next cycle
                ...
            end
            ...
        endcase
    end
  end

endmodule

module fsm (
    input  clk, rst,
    output rd,
    ...
);

  reg [BW-1:0] current_state, next_state;

  always_ff @(posedge clk, posedge rst) begin
    if (rst) current_state <= IDLE;       // reset state
    else     current_state <= next_state; // update state
  end

  always_comb begin
    next_state = X; // next state
    case (current_state)
        IDLE: begin
            // logic to change state
            if(start) next_state = READ;
            else      next_state = IDLE;
        end
        READ: begin
            next_state = ...; // logic to change state
        end
        ...
    endcase
  end

  always_comb begin
    next_rd      = 0;
    next_outputs = 0;
    ...
    case (current_state)
        READ: begin
            next_rd <= 1; // if current_state is READ, next_rd will be 1
            ...
        end
        ...
    endcase
  end

  always_ff @(posedge clk, posedge rst) begin
    if (rst) begin
        rd      <= 0; // reset rd output
        outputs <= 0; // reset outputs
        ...
    end
    else begin
        rd      <= next_rd; // update rd output
        outputs <= next_outputs; // update outputs
        ...
    end
  end

endmodule