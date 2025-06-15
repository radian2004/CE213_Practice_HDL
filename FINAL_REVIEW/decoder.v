/*
  1) Decoder 2-to-4:
     a) Mô hình cấu trúc
     b) Mô hình hành vi (dataflow) dùng continuous assignment
     c) Mô hình hành vi (behavioral) dùng procedural assignment
*/

//------------------------------------------------------------------------------
// a) Mô hình cấu trúc
//------------------------------------------------------------------------------
module decoder2to4_structural (
    input  wire       en,
    input  wire [1:0] a,
    output wire [3:0] y
);
  wire a0_n, a1_n;

  not u_not0(a0_n, a[0]);
  not u_not1(a1_n, a[1]);

  and u_and0(y[0], a1_n, a0_n, en);
  and u_and1(y[1], a1_n, a[0],  en);
  and u_and2(y[2], a[1],  a0_n, en);
  and u_and3(y[3], a[1],  a[0],  en);
endmodule

//------------------------------------------------------------------------------
// b) Mô hình hành vi (dataflow)
//------------------------------------------------------------------------------
module decoder2to4_dataflow (
    input  wire       en,
    input  wire [1:0] a,
    output wire [3:0] y
);
  assign y = en ? (4'b0001 << a) : 4'b0000;
endmodule

//------------------------------------------------------------------------------
// c) Mô hình hành vi (behavioral)
//------------------------------------------------------------------------------
module decoder2to4_behavioral (
    input  wire       en,
    input  wire [1:0] a,
    output reg  [3:0] y
);
  always @(*) begin
    if (!en)
      y = 4'b0000;
    else begin
      case (a)
        2'd0: y = 4'b0001;
        2'd1: y = 4'b0010;
        2'd2: y = 4'b0100;
        2'd3: y = 4'b1000;
        default: y = 4'b0000;
      endcase
    end
  end
endmodule
