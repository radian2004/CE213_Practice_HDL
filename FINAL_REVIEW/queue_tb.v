`timescale 1ns / 1ps 
module queue_tb;

    reg clk;
    reg rst;
    reg wr_en;
    reg rd_en;
    reg [7:0] din;
    wire [7:0] dout;
    wire full;
    wire empty;

    // Khởi tạo module FIFO
    queue fifo (
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .din(din),
        .dout(dout),
        .full(full),
        .empty(empty)
    );

    // Tạo xung clock
    always #5 clk = ~clk;

    initial begin
        // Khởi tạo giá trị ban đầu
        clk = 0;
        rst = 1;
        wr_en = 0;
        rd_en = 0;
        din = 0;

        // Reset FIFO
        #10 rst = 0;

        // Ghi dữ liệu vào FIFO
        #10 wr_en = 1; din = 8'h01;
        #10 din = 8'h02;
        #10 din = 8'h03;
        #10 din = 8'h04;
        #10 din = 8'h05;
        #10 din = 8'h06;
        #10 din = 8'h07;
        #10 din = 8'h08;
        #10 din = 8'h09;
        #10 din = 8'h0A;
        #10 din = 8'h0B;
        #10 din = 8'h0C;
        #10 din = 8'h0D;
        #10 din = 8'h0E;
        #10 din = 8'h0F;
        #10 din = 8'h10; // FIFO đầy sau khi ghi 16 phần tử

        // Thử ghi khi đầy
        #10 wr_en = 1; din = 8'h11; // Không ghi được

        // Đọc dữ liệu từ FIFO
        #10 wr_en = 0; rd_en = 1;
        #160; // Đọc 16 phần tử từ 8'h01 đến 8'h10

        // Thử đọc khi rỗng
        #10 rd_en = 1; // Không đọc được

        // Kết thúc simulation
        #10 $finish;
    end

    // Monitor để theo dõi giá trị
    initial begin
        $monitor("Time: %0t | rst: %b | wr_en: %b | rd_en: %b | din: %h | dout: %h | full: %b | empty: %b",
                 $time, rst, wr_en, rd_en, din, dout, full, empty);
    end

endmodule