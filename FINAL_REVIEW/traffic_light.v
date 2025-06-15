/*
  Thiết kế hệ thống đèn giao thông đơn giản tại ngã tư giữa đường chính và đường phụ.
  Nguyên tắc:
  - Bình thường: đường chính luôn được ưu tiên, đèn xanh sáng trong 60 giây.
  - Đường phụ chỉ được xanh nếu có yêu cầu từ cảm biến xe (req), khi đó đường chính chuyển vàng 5 giây rồi đỏ 30 giây.
  - Sau khi hết thời gian ưu tiên đường phụ, hệ thống quay lại trạng thái ban đầu.
  - Bộ đếm thời gian (timer) được kích hoạt bằng 1 tín hiệu start, reset bằng 1 tín hiệu rst.
    + Timer trả về tín hiệu state:
       3'b001 sau 5 giây
       3'b011 sau 30 giây
       3'b111 sau 60 giây
*/

//------------------------------------------------------------------------------
// module timer: đếm thời gian theo state code
//------------------------------------------------------------------------------
// Module timer: đếm thời gian theo state code
module timer (
  input  wire       clk,
  input  wire       rst,
  input  wire       start,
  output reg [2:0]  state       // mã thời gian
);
  reg [6:0] cnt;  // đủ chứa đến 60

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      cnt   <= 0;
      state <= 3'b000;
    end else if (start) begin
      cnt <= cnt + 1;
      case (cnt)
        7'd5:  state <= 3'b001;
        7'd30: state <= 3'b011;
        7'd60: state <= 3'b111;
        default: /* giữ state */;
      endcase
    end
  end
endmodule

// Module traffic_light: FSM điều khiển đèn chính và phụ
module traffic_light (
  input  wire clk,       // 1Hz
  input  wire rst,       // reset FSM
  input  wire req,       // yêu cầu từ đường phụ
  output reg  green_main,
  output reg  yellow_main,
  output reg  red_main,
  output reg  green_side,
  output reg  yellow_side,
  output reg  red_side
);
  // Định nghĩa mã trạng thái FSM
  localparam S_MAIN = 2'd0,
             S_WARN = 2'd1,
             S_SIDE = 2'd2;

  reg [1:0] state, next_state;
  wire [2:0] tm_state;

  // Timer instance
  reg timer_start;
  reg timer_rst;
  timer u_timer(
    .clk(clk), .rst(timer_rst), .start(timer_start), .state(tm_state)
  );

  // FSM state register
  always @(posedge clk or posedge rst) begin
    if (rst)
      state <= S_MAIN;
    else
      state <= next_state;
  end

  // Next-state logic & outputs
  always @(*) begin
    // Defaults
    {green_main, yellow_main, red_main} = 3'b000;
    {green_side, yellow_side, red_side} = 3'b000;
    timer_start   = 1'b0;
    timer_rst     = 1'b1;  // Hold reset inactive
    next_state    = state;

    case (state)
      S_MAIN: begin
        green_main  = 1;
        red_side    = 1;
        // Khởi động đếm 60s, reset timer nếu có req
        timer_rst   = req;
        timer_start = 1;
        if (tm_state == 3'b111 || req) begin
          next_state = S_WARN;
        end
      end
      S_WARN: begin
        yellow_main = 1;
        red_side    = 1;
        timer_rst   = 1'b0;
        timer_start = 1;
        if (tm_state == 3'b001) begin
          next_state = S_SIDE;
        end
      end
      S_SIDE: begin
        red_main    = 1;
        green_side  = 1;
        timer_rst   = 1'b0;
        timer_start = 1;
        if (tm_state == 3'b011) begin
          next_state = S_MAIN;
        end
      end
    endcase
  end
endmodule