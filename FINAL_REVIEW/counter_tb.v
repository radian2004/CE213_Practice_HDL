`timescale 1ns / 1ps

module counter_tb;
  reg clk, rst, load, up, hold;
  reg [3:0] d;
  wire [3:0] q;

  // Kết nối DUT
  counter dut (
    .clk(clk),
    .rst(rst),
    .load(load),
    .d(d),
    .up(up),
    .hold(hold),
    .q(q)
  );

  // Tạo xung clock
  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    // reset ban đầu
    rst = 1; load = 0; up = 1; hold = 0; d = 4'd5;
    $display("Time | rst load up hold | q");
    $monitor("%4t |  %b    %b   %b    %b   | %d", $time, rst, load, up, hold, q);

    #10 rst = 0;

    // load giá trị 5
    load = 1; #10;
    load = 0;

    // đếm xuôi 6 chu kỳ
    repeat (6) #10;

    // giữ giá trị 3 chu kỳ
    hold = 1; #30;
    hold = 0;

    // đếm ngược 4 chu kỳ
    up = 0; #40;

    $finish;
  end
endmodule
