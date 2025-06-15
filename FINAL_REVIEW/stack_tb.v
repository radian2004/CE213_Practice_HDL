// Testbench cho stack8
`timescale 1ns / 1ps 
// Testbench cho module stack
module stack_tb;

    // Inputs
    reg clk;
    reg rst;
    reg push;
    reg pop;
    reg [7:0] din;
    
    // Outputs
    wire [7:0] dout;
    wire full;
    wire empty;
    
    // Khởi tạo module stack
    stack uut (
        .clk(clk),
        .rst(rst),
        .push(push),
        .pop(pop),
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
        push = 0;
        pop = 0;
        din = 0;
        
        // Reset stack
        #10 rst = 0;
        
        // Push dữ liệu vào stack
        #10 push = 1; din = 8'h01;
        #10 din = 8'h02;
        #10 din = 8'h03;
        #10 din = 8'h04;
        #10 din = 8'h05;
        #10 din = 8'h06;
        #10 din = 8'h07;
        #10 din = 8'h08; // Stack đầy sau khi push 8 phần tử
        
        // Thử push khi đầy
        #10 push = 1; din = 8'h09; // Không push được
        
        // Pop dữ liệu từ stack
        #10 push = 0; pop = 1;
        #80; // Pop 8 phần tử từ 8'h08 đến 8'h01
        
        // Thử pop khi rỗng
        #10 pop = 1; // Không pop được
        
        // Kết thúc simulation
        #10 $finish;
    end
    
    // Monitor để theo dõi giá trị
    initial begin
        $monitor("Time: %0t | rst: %b | push: %b | pop: %b | din: %h | dout: %h | full: %b | empty: %b",
                 $time, rst, push, pop, din, dout, full, empty);
    end

endmodule