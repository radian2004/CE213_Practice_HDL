/*
  Thiết kế mạch Shift-Left 4-bit:
  - Input: din[3:0]
  - Output: dout[3:0]
  Khi kích hoạt tín hiệu shift (sh=1), dữ liệu dịch trái 1 bit; 
  vị trí LSB chèn 0.
  Yêu cầu:
    1) Mô hình cấu trúc (structural): sử dụng cổng cơ bản (and, or, not)
    2) Mô hình hành vi (dataflow): chỉ dùng continuous assignment
    3) Mô hình hành vi (behavioral): chỉ dùng procedural assignment trong always
*/

//------------------------------------------------------------------------------
// 1) Mô hình cấu trúc
//------------------------------------------------------------------------------
module shl4_structural (
    input  wire [3:0] din,
    input  wire       sh,
    output wire [3:0] dout
);
  wire s;
  not u_not(s, sh);

  // khi sh=1: dout = {din[2:0], 1'b0}
  // khi sh=0: dout = din
  wire [3:0] pass;
  assign pass = din;

  // tạo các bit đầu ra
  and u_and0(dout[3], din[2], sh);
  and u_and1(dout[2], din[1], sh);
  and u_and2(dout[1], din[0], sh);
  and u_and3(dout[0], 1'b0,    sh);

  // giữ nguyên khi sh=0
  and u_and4(dout[3], pass[3], s);
  and u_and5(dout[2], pass[2], s);
  and u_and6(dout[1], pass[1], s);
  and u_and7(dout[0], pass[0], s);

  // or kết hợp
  or  u_or0(dout[3], dout[3], dout[3]);
  or  u_or1(dout[2], dout[2], dout[2]);
  or  u_or2(dout[1], dout[1], dout[1]);
  or  u_or3(dout[0], dout[0], dout[0]);
endmodule

//------------------------------------------------------------------------------
// 2) Mô hình hành vi (dataflow)
//------------------------------------------------------------------------------
module shl4_dataflow (
    input  wire [3:0] din,
    input  wire       sh,
    output wire [3:0] dout
);
  // khi sh=1: shift left bằng toán tử <<, chèn 0
  // khi sh=0: giữ nguyên
  assign dout = sh ? (din << 1) : din;
endmodule

//------------------------------------------------------------------------------
// 3) Mô hình hành vi (behavioral)
//------------------------------------------------------------------------------
module shl4_behavioral (
    input  wire [3:0] din,
    input  wire       sh,
    output reg  [3:0] dout
);
  always @(*) begin
    if (sh)
      dout = din << 1;
    else
      dout = din;
  end
endmodule
