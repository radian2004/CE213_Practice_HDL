/*
  Thiết kế Stack 8×8-bit (LIFO), đồng bộ theo clk:
  - Depth: 8 entries
  - Stack pointer sp (3-bit)
  - Inputs:
      clk, rst       : reset về empty
      push, pop      : điều khiển ghi/rút
      din [7:0]      : dữ liệu đẩy
  - Outputs:
      dout [7:0]     : dữ liệu ở top
      full, empty    : cờ báo đầy/rỗng
*/

module stack (
    input wire clk,          // Xung clock để đồng bộ
    input wire rst,          // Reset để đưa stack về trạng thái rỗng
    input wire push,         // Tín hiệu đẩy dữ liệu vào stack
    input wire pop,          // Tín hiệu rút dữ liệu khỏi stack
    input wire [7:0] din,    // Dữ liệu 8-bit đầu vào
    output reg [7:0] dout,   // Dữ liệu 8-bit ở đỉnh stack
    output wire full,        // Cờ báo stack đầy
    output wire empty        // Cờ báo stack rỗng
);

    reg [7:0] mem [0:7];     // Bộ nhớ stack: 8 phần tử, mỗi phần tử 8-bit
    reg [2:0] sp;            // Stack pointer: 3-bit để chỉ đến 8 vị trí

    // Gán cờ full và empty dựa trên giá trị của stack pointer
    assign empty = (sp == 3'd0);  // Rỗng khi sp = 0
    assign full = (sp == 3'd7);   // Đầy khi sp = 7 (vì stack có 8 phần tử)

    // Logic đồng bộ với xung clock và reset
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sp <= 3'd0;       // Reset stack pointer về 0
            dout <= 8'd0;     // Đặt dout về 0 khi reset (tùy chọn)
        end else begin
            if (push && !full) begin
                mem[sp] <= din;    // Ghi dữ liệu vào vị trí sp
                sp <= sp + 1;      // Tăng stack pointer
                dout <= din;       // Cập nhật dout thành dữ liệu vừa đẩy vào (đỉnh mới)
            end else if (pop && !empty) begin
                sp <= sp - 1;      // Giảm stack pointer
                if (sp > 0) begin
                    dout <= mem[sp - 1]; // Cập nhật dout thành dữ liệu ở đỉnh mới
                end else begin
                    dout <= 8'd0;      // Khi stack rỗng sau pop, dout = 0
                end
            end
        end
    end

endmodule