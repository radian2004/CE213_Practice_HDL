/*
  ALU 8-bit:
  Thực hiện phép:
    000: a + b
    001: a - b
    010: a & b
    011: a | b
    100: a ^ b
    101: a << 1 (logic shift)
    110: a >> 1 (logic shift)
    111: compare: eq, gt
  Outputs:
    y[7:0]    kết quả hoặc y=1 khi eq/gt
    carry      cờ carry/borrow
    overflow   cờ tràn số học
    zero       cờ kết quả bằng 0
*/

module alu (
  input  wire [7:0] a,
  input  wire [7:0] b,
  input  wire [2:0] op,
  output reg  [7:0] y,
  output reg        carry,
  output reg        overflow,
  output reg        zero
);
  reg [8:0] tmp;

  always @(*) begin
    // default flags
    carry    = 0;
    overflow = 0;
    case (op)
      3'b000: begin // add
        tmp = {1'b0, a} + {1'b0, b};
        y = tmp[7:0];
        carry = tmp[8];
        // overflow cho signed
        overflow = (a[7] == b[7]) && (y[7] != a[7]);
      end
      3'b001: begin // sub
        tmp = {1'b0, a} - {1'b0, b};
        y = tmp[7:0];
        carry = ~tmp[8];        // borrow flag
        overflow = (a[7] != b[7]) && (y[7] != a[7]);
      end
      3'b010: y = a & b;
      3'b011: y = a | b;
      3'b100: y = a ^ b;
      3'b101: begin // shift left
        y = a << 1;
        carry = a[7];
      end
      3'b110: begin // shift right logical
        y = a >> 1;
        carry = a[0];
      end
      3'b111: begin // compare
        y = 8'd0;
        if (a == b) y = 8'd1;
        else if (a > b) y = 8'd2;
      end
      default: y = 8'd0;
    endcase
    zero = (y == 8'd0);
  end
endmodule