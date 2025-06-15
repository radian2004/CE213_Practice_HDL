/*
  Thiết kế bộ điều khiển thang máy phục vụ 3 tầng (0,1,2).
  Yêu cầu:
  - 3 tín hiệu req[2:0] gọi thang từ tầng 0,1,2
  - cur_floor[1:0]: vị trí hiện tại (00,01,10)
  - dir_up, dir_down: điều khiển động cơ
  - door_open: điều khiển cửa
  - Thứ tự phục vụ: ưu tiên req từ dưới lên
  - Khi đến tầng có req, mở cửa 5s rồi đóng, tiếp tục phục vụ
*/
module elevator (
  input  wire        clk,
  input  wire        rst,
  input  wire [2:0]  req,
  input  wire [1:0]  cur_floor,
  output reg         dir_up,
  output reg         dir_down,
  output reg         door_open
);
  localparam IDLE=2'd0, MOVING=2'd1, DOOR=2'd2;
  reg [1:0] state, next_state;
  reg [1:0] target;
  reg [2:0] pending;
  reg [2:0] timer;

  // Cập nhật pending
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      pending <= 3'b000;
    end else begin
      pending <= pending | req;
      if (state == DOOR && timer == 3'd5) begin
        pending[target] <= 1'b0;
      end
    end
  end

  // State register và timer
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      state <= IDLE;
      timer <= 0;
      target <= 0;
    end else begin
      state <= next_state;
      if (state == DOOR) begin
        if (timer < 3'd5) begin
          timer <= timer + 1;
        end else begin
          timer <= 0;
        end
      end else begin
        timer <= 0;
      end
    end
  end

  // Next state & outputs
  always @(*) begin
    dir_up = 0;
    dir_down = 0;
    door_open = 0;
    next_state = state;
    case(state)
      IDLE: begin
        if (pending[0]) target = 2'd0;
        else if (pending[1]) target = 2'd1;
        else if (pending[2]) target = 2'd2;
        else target = cur_floor;
        if (target != cur_floor) begin
          next_state = MOVING;
        end else if (|pending) begin
          next_state = DOOR;
        end
      end
      MOVING: begin
        if (cur_floor < target) begin
          dir_up = 1;
        end else if (cur_floor > target) begin
          dir_down = 1;
        end
        if (cur_floor == target) begin
          next_state = DOOR;
        end
      end
      DOOR: begin
        door_open = 1;
        if (timer == 3'd5) begin
          next_state = IDLE;
        end
      end
    endcase
  end
endmodule