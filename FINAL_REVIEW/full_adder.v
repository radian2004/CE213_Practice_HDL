/*
  Thiết kế mạch Full-Adder 4-bit (cộng 4-bit với cộng có nhớ vào và xuất ra carry-out):
  - Inputs: a[3:0], b[3:0], cin
  - Outputs: sum[3:0], cout
  Yêu cầu:
    1) Mô hình cấu trúc (structural): xài full-adder 1 bit lồng nhau
    2) Mô hình hành vi (dataflow): chỉ dùng continuous assignment
    3) Mô hình hành vi (behavioral): chỉ dùng procedural assignment trong always
*/

//------------------------------------------------------------------------------
// 1) Mô hình cấu trúc (structural)
//------------------------------------------------------------------------------
// full-adder 1 bit cơ bản
module fa1 (
  input  wire a,
  input  wire b,
  input  wire cin,
  output wire sum,
  output wire cout
);
  wire s1, c1, c2;
  xor (s1, a, b);
  xor (sum, s1, cin);
  and (c1, a, b);
  and (c2, s1, cin);
  or  (cout, c1, c2);
endmodule

// full-adder 4 bit
module fa4_structural (
  input  wire [3:0] a,
  input  wire [3:0] b,
  input  wire       cin,
  output wire [3:0] sum,
  output wire       cout
);
  wire c1, c2, c3;
  fa1 u0(.a(a[0]), .b(b[0]), .cin(cin), .sum(sum[0]), .cout(c1));
  fa1 u1(.a(a[1]), .b(b[1]), .cin(c1),  .sum(sum[1]), .cout(c2));
  fa1 u2(.a(a[2]), .b(b[2]), .cin(c2),  .sum(sum[2]), .cout(c3));
  fa1 u3(.a(a[3]), .b(b[3]), .cin(c3),  .sum(sum[3]), .cout(cout));
endmodule

//------------------------------------------------------------------------------
// 2) Mô hình hành vi (dataflow)
//------------------------------------------------------------------------------
module fa4_dataflow (
  input  wire [3:0] a,
  input  wire [3:0] b,
  input  wire       cin,
  output wire [3:0] sum,
  output wire       cout
);
  // ghép sang vector 5-bit và cộng
  wire [4:0] tmp;
  assign tmp = a + b + cin;
  assign sum  = tmp[3:0];
  assign cout = tmp[4];
endmodule

//------------------------------------------------------------------------------
// 3) Mô hình hành vi (behavioral)
//------------------------------------------------------------------------------
module fa4_behavioral (
  input  wire [3:0] a,
  input  wire [3:0] b,
  input  wire       cin,
  output reg  [3:0] sum,
  output reg        cout
);
  reg [4:0] tmp;
  always @(*) begin
    tmp  = a + b + cin;
    sum  = tmp[3:0];
    cout = tmp[4];
  end
endmodule
