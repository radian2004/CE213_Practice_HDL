`timescale 1ns / 1ps

module locker_tb;
  // signals
  reg         clk, reset;
  reg  [3:0]  key_in;
  reg         key_valid, enter;
  wire        open, error;

  // instantiate FSM locker
  locker dut (
    .clk(clk), .reset(reset), .key_in(key_in),
    .key_valid(key_valid), .enter(enter),
    .open(open), .error(error)
  );

  // clock: 100 MHz
  initial clk = 0;
  always #5 clk = ~clk;

  // task for entering code
  task input_code;
    input [3:0] d0, d1, d2, d3;
    integer idx;
    reg [3:0] codes [0:3];
    begin
      codes[0] = d0; codes[1] = d1;
      codes[2] = d2; codes[3] = d3;
      for (idx = 0; idx < 4; idx = idx + 1) begin
        @(posedge clk) begin
          key_in    = codes[idx];
          key_valid = 1;
        end
        @(posedge clk) begin
          key_valid = 0;
        end
      end
      // enter
      @(posedge clk) enter = 1;
      @(posedge clk) enter = 0;
      // capture output next cycle
      @(posedge clk);
      $display("%4t: open=%b error=%b", $time, open, error);
    end
  endtask

  initial begin
    // initialize
    reset     = 1;
    key_valid = 0;
    enter     = 0;
    key_in    = 0;

    $display("Time    rst kv en key | open error");
    $display("--------------------------------");
    $monitor("%4t    %b   %b  %b  %1d  |   %b   %b", $time,
             reset, key_valid, enter, key_in, open, error);

    // release reset
    #20; reset = 0;

    // 1) correct sequence
    $display("-- Test correct code 4-2-7-9 --");
    input_code(4,2,7,9);

    // 2) wrong sequence
    $display("-- Test wrong code 1-1-1-1 --");
    input_code(1,1,1,1);

    // 3) partial input and enter
    $display("-- Test enter before full input --");
    @(posedge clk);
      key_in = 4; key_valid = 1;
    @(posedge clk) key_valid = 0;
    @(posedge clk) enter = 1;
    @(posedge clk) enter = 0;
    @(posedge clk);
    $display("%4t: open=%b error=%b", $time, open, error);

    // 4) reset during input
    $display("-- Test reset mid-input --");
    @(posedge clk) begin
      key_in    = 4; key_valid = 1;
    end
    @(posedge clk) begin
      reset     = 1;
      key_valid = 0;
    end
    @(posedge clk) reset = 0;
    // then input correct
    input_code(4,2,7,9);

    $finish;
  end
endmodule