/*
  Thiết kế mạch Half-Adder 4-bit:
  - Inputs: a[3:0], b[3:0]
  - Outputs: sum[3:0], carry[3:0]
  Mỗi bit sử dụng Half-Adder cơ bản (sum = a xor b, carry = a & b).
  Yêu cầu:
  1) Mô hình cấu trúc (structural): sử dụng 4 module Half-Adder 1-bit
  2) Mô hình hành vi (dataflow): chỉ dùng continuous assignment
  3) Mô hình hành vi (behavioral): chỉ dùng procedural assignment trong always
*/

//------------------------------------------------------------------------------
// 1) Mô hình cấu trúc
//------------------------------------------------------------------------------
// half-adder 1 bit
module ha1 (
  input  wire a,
  input  wire b,
  output wire sum,
  output wire carry
);
  xor (sum, a, b);
  and (carry, a, b);
endmodule

// half-adder 4 bit structural
module half_adder (
  input  wire [3:0] a,
  input  wire [3:0] b,
  output wire [3:0] sum,
  output wire [3:0] carry
);
  ha1 u0(.a(a[0]), .b(b[0]), .sum(sum[0]), .carry(carry[0]));
  ha1 u1(.a(a[1]), .b(b[1]), .sum(sum[1]), .carry(carry[1]));
  ha1 u2(.a(a[2]), .b(b[2]), .sum(sum[2]), .carry(carry[2]));
  ha1 u3(.a(a[3]), .b(b[3]), .sum(sum[3]), .carry(carry[3]));
endmodule

//------------------------------------------------------------------------------
// 2) Mô hình hành vi (dataflow)
//------------------------------------------------------------------------------
module ha4_dataflow (
  input  wire [3:0] a,
  input  wire [3:0] b,
  output wire [3:0] sum,
  output wire [3:0] carry
);
  // sum = a xor b, carry = a & b, vectorized
  assign sum   = a ^ b;
  assign carry = a & b;
endmodule

//------------------------------------------------------------------------------
// 3) Mô hình hành vi (behavioral)
//------------------------------------------------------------------------------
module ha4_behavioral (
  input  wire [3:0] a,
  input  wire [3:0] b,
  output reg  [3:0] sum,
  output reg  [3:0] carry
);
  integer i;
  always @(*) begin
    for (i = 0; i < 4; i = i+1) begin
      sum[i]   = a[i] ^ b[i];
      carry[i] = a[i] & b[i];
    end
  end
endmodule
