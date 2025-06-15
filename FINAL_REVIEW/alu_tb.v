`timescale 1ns / 1ps

module alu_tb;
  reg [7:0] a, b;
  reg [2:0] op;
  wire [7:0] y;
  wire carry, overflow, zero;

  // Instantiate DUT
  alu dut (
    .a(a),
    .b(b),
    .op(op),
    .y(y),
    .carry(carry),
    .overflow(overflow),
    .zero(zero)
  );

  integer i, j;
  reg [7:0] test_a [0:3];
  reg [7:0] test_b [0:3];

  initial begin
    // Define test vectors
    test_a[0] = 8'd0;   test_b[0] = 8'd0;
    test_a[1] = 8'd15;  test_b[1] = 8'd1;
    test_a[2] = 8'd127; test_b[2] = 8'd1;
    test_a[3] = 8'd200; test_b[3] = 8'd55;

    $display("===============================================");
    $display(" ALU TESTBENCH");
    $display(" op   a     b   |   y   carry ovfl zero");
    $display("===============================================");

    for (j = 0; j < 8; j = j + 1) begin
      op = j[2:0];  // map integer j to 3-bit opcode
      for (i = 0; i < 4; i = i + 1) begin
        a = test_a[i];
        b = test_b[i];
        #10;
        $display(" %03b %4d %4d | %4d    %b     %b    %b", 
                  op, a, b, y, carry, overflow, zero);
      end
    end

    $display("===============================================");
    $finish;
  end
endmodule
