/*
  Module khóa số điện tử theo FSM
  Mã cố định: 4, 2, 7, 9
  Trạng thái:
    IDLE   - chờ nhập
    INPUT  - thu thập 4 chữ số
    VERIFY - chờ nhấn Enter
    OUTPUT - xuất open hoặc error
*/
`timescale 1ns / 1ps
module locker (
    input  wire       clk,
    input  wire       reset,
    input  wire [3:0] key_in,
    input  wire       key_valid,
    input  wire       enter,
    output reg        open,
    output reg        error
);
  // mã cố định
  localparam [3:0] CODE0 = 4'd4;
  localparam [3:0] CODE1 = 4'd2;
  localparam [3:0] CODE2 = 4'd7;
  localparam [3:0] CODE3 = 4'd9;

  // FSM states
  localparam IDLE   = 2'd0,
             INPUT  = 2'd1,
             VERIFY = 2'd2,
             OUTPUT = 2'd3;

  reg [1:0] state, next_state;
  reg [1:0] count;
  reg [3:0] buffer [0:3];
  integer   i;

  // state register
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= IDLE;
      count <= 2'd0;
      open  <= 1'b0;
      error <= 1'b0;
      for (i = 0; i < 4; i = i + 1)
        buffer[i] <= 4'd0;
    end else begin
      state <= next_state;
    end
  end

  // next-state logic
  always @(*) begin
    // defaults
    next_state = state;
    case (state)
      IDLE: begin
        if (key_valid)
          next_state = INPUT;
      end
      INPUT: begin
        if (key_valid && count == 2'd3)
          next_state = VERIFY;
      end
      VERIFY: begin
        if (enter)
          next_state = OUTPUT;
      end
      OUTPUT: begin
        next_state = IDLE;
      end
    endcase
  end

  // outputs and data path
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      count <= 2'd0;
      open  <= 1'b0;
      error <= 1'b0;
    end else begin
      // default clear outputs in non-OUTPUT state
      if (state != OUTPUT) begin
        open  <= 1'b0;
        error <= 1'b0;
      end

      case (state)
        IDLE: begin
          if (key_valid) begin
            buffer[0] <= key_in;
            count <= 2'd1;
          end
        end
        INPUT: begin
          if (key_valid) begin
            buffer[count] <= key_in;
            count <= count + 1;
          end
        end
        VERIFY: begin
          // nothing until enter
        end
        OUTPUT: begin
          // kiểm tra mã
          if ({buffer[0], buffer[1], buffer[2], buffer[3]} == {CODE0, CODE1, CODE2, CODE3})
            open <= 1'b1;
          else
            error <= 1'b1;
          // reset counter for next round
          count <= 2'd0;
          // clear buffer
          for (i = 0; i < 4; i = i + 1)
            buffer[i] <= 4'd0;
        end
      endcase
    end
  end
endmodule
