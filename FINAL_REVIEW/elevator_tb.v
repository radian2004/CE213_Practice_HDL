//------------------------------------------------------------------------------
// Testbench cải tiến cho elevator
//------------------------------------------------------------------------------
`timescale 1ns/1ps
module elevator_tb;
  reg        clk, rst;
  reg [2:0]  req;
  reg [1:0]  cur_floor;
  wire       dir_up, dir_down, door_open;

  elevator dut(
    .clk(clk), .rst(rst), .req(req), .cur_floor(cur_floor),
    .dir_up(dir_up), .dir_down(dir_down), .door_open(door_open)
  );

  // Clock 1Hz (period 1000 ns)
  initial clk=0; always #500 clk = ~clk;

  initial begin
    $display("Time  req  cur  up dn door pending state");
    $monitor("%4t   %b   %b   %b  %b   %b    pending=%b state=%d", $time, req, cur_floor,
             dir_up, dir_down, door_open, dut.pending, dut.state);

    // Reset
    rst=1; req=3'b000; cur_floor=2'd0;
    #1000; rst=0;

    // Gọi tầng 2
    req = 3'b100; #1000;
    cur_floor = 2'd1; #1000;
    cur_floor = 2'd2; #1000;
    #5000; // Chờ mở cửa 5s

    // Gọi tầng 1 và 0 cùng lúc
    req = 3'b011; #1000;
    cur_floor = 2'd1; #1000;
    cur_floor = 2'd0; #1000;
    #5000;

    // Gọi từ tầng 1 khi đang ở tầng 0
    req = 3'b010; #1000;
    cur_floor = 2'd1; #1000;
    #5000;

    // Gọi từ tầng 2 và 0 cùng lúc
    req = 3'b101; #1000;
    cur_floor = 2'd2; #1000;
    #5000;
    cur_floor = 2'd0; #1000;
    #5000;

    $finish;
  end
endmodule
