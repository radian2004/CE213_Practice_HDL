//------------------------------------------------------------------------------
// Testbench cho traffic_light
//------------------------------------------------------------------------------
`timescale 1ns / 1ps
module traffic_light_tb;
  reg clk, rst;
  reg req;
  wire gm, ym, rm, gs, ys, rs;

  traffic_light dut (
    .clk(clk), .rst(rst), .req(req),
    .green_main(gm), .yellow_main(ym), .red_main(rm),
    .green_side(gs), .yellow_side(ys), .red_side(rs)
  );

  // Tạo clock 1 Hz
  initial clk = 0;
  always #500 clk = ~clk; // Giả 1s = 1000 timeunit

  initial begin
    // Reset
    rst = 1; req = 0;
    #1000; rst = 0;

    // Trường hợp bình thường, chạy 60s
    #61000;
    $display("Transfer to yellow after 60s: ym=%b", ym);

    // Yêu cầu đường phụ
    req = 1;
    #1000; req = 0; // Kích hoạt yêu cầu
    #6000;  // 5s warn
    $display("Warn complete: ym=%b, rm=%b", ym, rm);
    #30000; // 30s side
    $display("Side complete, comeback main: gm=%b, gs=%b", gm, gs);

    // Thêm trường hợp kiểm tra: yêu cầu từ đường phụ khi đang ở S_MAIN
    req = 1;
    #1000; req = 0;
    #6000;  // 5s warn
    $display("Warn complete the second: ym=%b, rm=%b", ym, rm);
    #30000; // 30s side
    $display("Side complete the second, comeback main: gm=%b, gs=%b", gm, gs);

    $finish;
  end
endmodule