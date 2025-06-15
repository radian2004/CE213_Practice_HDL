/*
  Thiết kế mạch Multiplexer 4-to-1:
  - Input: sel[1:0], d0, d1, d2, d3
  - Output: y
  Yêu cầu:
  1) Mô hình cấu trúc (structural): dùng cổng cơ bản (and/or/not)
  2) Mô hình hành vi (dataflow): chỉ sử dụng continuous assignment
  3) Mô hình hành vi (behavioral): chỉ sử dụng procedural assignment trong always
*/

//------------------------------------------------------------------------------
// 1) Mô hình cấu trúc
//------------------------------------------------------------------------------
module mux4to1_structural (
    input  wire [3:0] d0,
    input  wire [3:0] d1,
    input  wire [3:0] d2,   
    input  wire [3:0] d3,
    input  wire [1:0] sel,
    output wire [3:0] y
);
  wire [3:0] and0, and1, and2, and3;

  // bit mask theo selector
  assign and0 = d0 & {4{~sel[1] & ~sel[0]}};
  assign and1 = d1 & {4{~sel[1] &  sel[0]}};
  assign and2 = d2 & {4{ sel[1] & ~sel[0]}};
  assign and3 = d3 & {4{ sel[1] &  sel[0]}};

  assign y = and0 | and1 | and2 | and3;
endmodule


//------------------------------------------------------------------------------
// 2) Mô hình hành vi (dataflow)
//------------------------------------------------------------------------------
module mux4to1_dataflow (
    input  wire [3:0] d0,
    input  wire [3:0] d1,
    input  wire [3:0] d2,   
	  input  wire [3:0] d3,
    input  wire [1:0] sel,
    output wire [3:0] y
);
  // dùng toán tử shift và bitwise select
  assign y = (sel == 2'd0) ? d0 :
             (sel == 2'd1) ? d1 :
             (sel == 2'd2) ? d2 :
                              d3;
endmodule

//------------------------------------------------------------------------------
// 3) Mô hình hành vi (behavioral)
//------------------------------------------------------------------------------
module mux4to1_behavioral (
    input  wire [3:0] d0,
    input  wire [3:0] d1,
    input  wire [3:0] d2,   
    input  wire [3:0] d3,
    input  wire [1:0] sel,
    output reg  [3:0] y  // sửa: reg thay vì wire
);
  always @(*) begin
    case (sel)
      2'd0: y = d0;
      2'd1: y = d1;
      2'd2: y = d2;
      2'd3: y = d3;
      default: y = 4'b0000;
    endcase
  end
endmodule