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
module demux1to4_structural_1bit (
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
  and u_and0(y0, d,  s1_n, s0_n);
  and u_and1(y1, d,  s1_n, sel[0]);
  and u_and2(y2, d,  sel[1], s0_n);
  and u_and3(y3, d,  sel[1], sel[0]);
endmodule

module demux1to4_structural (
  input  wire [3:0] d,
  input  wire [1:0] sel,
  output wire [3:0] y0,
  output wire [3:0] y1,
  output wire [3:0] y2,
  output wire [3:0] y3
);
  // instantiate 4 bit‑wide demuxes (mỗi bit riêng)
  demux1to4_structural_1bit dm0 (
    .d    (d[0]),
    .sel  (sel),
    .y0   (y0[0]),
    .y1   (y1[0]),
    .y2   (y2[0]),
    .y3   (y3[0])
  );
  demux1to4_structural_1bit dm1 (
    .d    (d[1]),
    .sel  (sel),
    .y0   (y0[1]),
    .y1   (y1[1]),
    .y2   (y2[1]),
    .y3   (y3[1])
  );
  demux1to4_structural_1bit dm2 (
    .d    (d[2]),
    .sel  (sel),
    .y0   (y0[2]),
    .y1   (y1[2]),
    .y2   (y2[2]),
    .y3   (y3[2])
  );
  demux1to4_structural_1bit dm3 (
    .d    (d[3]),
    .sel  (sel),
    .y0   (y0[3]),
    .y1   (y1[3]),
    .y2   (y2[3]),
    .y3   (y3[3])
  );
endmodule

//------------------------------------------------------------------------------
// 2) Mô hình hành vi (dataflow)
//------------------------------------------------------------------------------
module demux1to4_dataflow (
  input  wire [3:0] d,
  input  wire [1:0] sel,
  output wire [3:0] y0,
  output wire [3:0] y1,
  output wire [3:0] y2,
  output wire [3:0] y3
);
  // nếu sel==X thì yX=d, ngược lại =0
  assign y0 = (sel == 2'd0) ? d : 4'b0000;
  assign y1 = (sel == 2'd1) ? d : 4'b0000;
  assign y2 = (sel == 2'd2) ? d : 4'b0000;
  assign y3 = (sel == 2'd3) ? d : 4'b0000;
endmodule

//------------------------------------------------------------------------------
// 3) Mô hình hành vi (behavioral)
//------------------------------------------------------------------------------
module demux1to4_behavioral (
  input  wire [3:0] d,
  input  wire [1:0] sel,
  output reg  [3:0] y0,
  output reg  [3:0] y1,
  output reg  [3:0] y2,
  output reg  [3:0] y3
);
  always @(*) begin
    // default tất cả = 0
    y0 = 4'b0000;
    y1 = 4'b0000;
    y2 = 4'b0000;
    y3 = 4'b0000;
    case (sel)
      2'd0: y0 = d;
      2'd1: y1 = d;
      2'd2: y2 = d;
      2'd3: y3 = d;
    endcase
  end
endmodule
