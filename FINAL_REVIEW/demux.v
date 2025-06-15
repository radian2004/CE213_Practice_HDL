/*
  Thiết kế mạch Demultiplexer 1-to-4:
  - Input: sel[1:0], d
  - Outputs: y0, y1, y2, y3
  Yêu cầu:
  1) Mô hình cấu trúc (structural): dùng cổng cơ bản (and/or/not)
  2) Mô hình hành vi (dataflow): chỉ sử dụng continuous assignment
  3) Mô hình hành vi (behavioral): chỉ sử dụng procedural assignment trong always
*/

//------------------------------------------------------------------------------
// 1) Mô hình cấu trúc
//------------------------------------------------------------------------------
module demux1to4_structural (
    input  wire       d,
    input  wire [1:0] sel,
    output wire       y0,
    output wire       y1,
    output wire       y2,
    output wire       y3
);
  wire s0_n, s1_n;

  // invert selectors
  not u_not0(s0_n, sel[0]);
  not u_not1(s1_n, sel[1]);

  // generate outputs
  and u_and0(y0, d, s1_n, s0_n);
  and u_and1(y1, d, s1_n, sel[0]);
  and u_and2(y2, d, sel[1], s0_n);
  and u_and3(y3, d, sel[1], sel[0]);
endmodule

//------------------------------------------------------------------------------
// 2) Mô hình hành vi (dataflow)
//------------------------------------------------------------------------------
module demux1to4_dataflow (
    input  wire       d,
    input  wire [1:0] sel,
    output wire       y0,
    output wire       y1,
    output wire       y2,
    output wire       y3
);
  assign y0 = (sel == 2'd0) ? d : 1'b0;
  assign y1 = (sel == 2'd1) ? d : 1'b0;
  assign y2 = (sel == 2'd2) ? d : 1'b0;
  assign y3 = (sel == 2'd3) ? d : 1'b0;
endmodule

//------------------------------------------------------------------------------
// 3) Mô hình hành vi (behavioral)
//------------------------------------------------------------------------------
module demux1to4_behavioral (
    input  wire       d,
    input  wire [1:0] sel,
    output reg        y0,
    output reg        y1,
    output reg        y2,
    output reg        y3
);
  always @(*) begin
    // default
    y0 = 1'b0; y1 = 1'b0; y2 = 1'b0; y3 = 1'b0;
    case (sel)
      2'd0: y0 = d;
      2'd1: y1 = d;
      2'd2: y2 = d;
      2'd3: y3 = d;
    endcase
  end
endmodule