/*
  Bộ đếm 4-bit có:
  - Đếm xuôi (up) hoặc ngược (down) mỗi chu kỳ clock
  - Load giá trị ban đầu (load)
  - Stop đếm khi có tín hiệu hold
  - Reset về giá trị mặc định
  - Chu trình đếm tùy chọn: ví dụ đếm vòng tròn 5->6->2->5 như hình
*/

module counter (
  input  wire        clk,
  input  wire        rst,       // reset về giá trị ban đầu
  input  wire        load,      // nạp dữ liệu
  input  wire [3:0]  d,         // giá trị nạp
  input  wire        up,        // 1: đếm lên, 0: đếm xuống
  input  wire        hold,      // 1: dừng đếm
  output reg  [3:0]  q          // giá trị đếm
);
  // định nghĩa chu trình đếm ring tùy chọn
  function [3:0] next_val;
    input [3:0] curr;
    input       up;
    begin
      case ({curr, up})
        // chu trình ví dụ: 5->6->2->5  (up=1)
        {4'd5,1'b1}: next_val = 4'd6;
        {4'd6,1'b1}: next_val = 4'd2;
        {4'd2,1'b1}: next_val = 4'd5;
        // ngược lại chu trình đảo ngược: 5<-6<-2<-5
        {4'd6,1'b0}: next_val = 4'd5;
        {4'd2,1'b0}: next_val = 4'd6;
        {4'd5,1'b0}: next_val = 4'd2;
        default:
          // mặc định: cộng/trừ 1 vòng 0..15
          next_val = up ? curr + 1 : curr - 1;
      endcase
    end
  endfunction

  always @(posedge clk or posedge rst) begin
    if (rst)
      q <= 4'd0;
    else if (load)
      q <= d;
    else if (!hold)
      q <= next_val(q, up);
  end
endmodule