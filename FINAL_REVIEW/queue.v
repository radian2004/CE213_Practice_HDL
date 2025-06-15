/*
  Thiết kế mạch Queue FIFO 16 phần tử, mỗi phần tử 8-bit
  Nguyên tắc FIFO (First In First Out)
  - Kích thước: 16 entry
  - Inputs:
    clk       : xung clock
    rst       : reset (xóa queue)
    wr_en     : ghi dữ liệu
    rd_en     : đọc dữ liệu
    din [7:0] : dữ liệu vào
  - Outputs:
    dout [7:0]: dữ liệu ra
    full      : cờ báo đầy
    empty     : cờ báo rỗng
*/

module queue (
  input  wire       clk,
  input  wire       rst,
  input  wire       wr_en,
  input  wire       rd_en,
  input  wire [7:0] din,
  output reg  [7:0] dout,
  output wire       full,
  output wire       empty
);
  // bộ nhớ 16x8
  reg [7:0] mem [0:15];
  reg [3:0] wr_ptr, rd_ptr;
  reg [4:0] count; // đếm số phần tử (0..16)

  // cờ full/empty
  assign empty = (count == 0);
  assign full  = (count == 16);

  // ghi và đọc
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      wr_ptr <= 0;
      rd_ptr <= 0;
      count  <= 0;
      dout   <= 8'd0;
    end else begin
      // ghi
      if (wr_en && !full) begin
        mem[wr_ptr] <= din;
        wr_ptr <= wr_ptr + 1;
      end
      // đọc
      if (rd_en && !empty) begin
        dout <= mem[rd_ptr];
        rd_ptr <= rd_ptr + 1;
      end
      // cập nhật count
      case ({wr_en && !full, rd_en && !empty})
        2'b10: count <= count + 1;
        2'b01: count <= count - 1;
        default: count <= count;
      endcase
    end
  end
endmodule
