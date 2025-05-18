`timescale 1ns/1ps

module tb_Lab3_Moore;
    reg        CLK;
    reg        RST;
    reg [3:0]  dataIn;
    wire       odd;

    // Instantiate the design under test with named ports
    Lab3_Moore dut (
        .CLK(CLK),
        .dataIn(dataIn),
        .RST(RST),
        .odd(odd)
    );

    // Waveform dump
    initial begin
        $dumpfile("Lab3_Moore_tb.vcd");
        $dumpvars(0, tb_Lab3_Moore);
    end

    // Clock generation: 10 ns period
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

    // Task to drive a sequence of 4 digits.
    // The 16-bit input is structured as {digit0, digit1, digit2, digit3}
    // where digit0 is the first input.
    task drive_sequence;
        input [15:0] seq;
        integer i;
        reg [3:0] digit;
        begin
            // Apply each digit every 10 ns
            for(i = 3; i >= 0; i = i - 1) begin
                // Extract 4 bits per digit using bit slicing.
                digit = seq[(i*4) + 3 -: 4];
                dataIn = digit;
                #10;
            end
        end
    endtask

    initial begin
        // Initialization & reset
        RST = 1;
        dataIn = 4'd0;
        #10;
        RST = 0;
        #10;
        
        // Test Case 1: "0025" (Expected: sum = 0+0+2+5 = 7, odd=1)
        $display("Test Case 1: 0025");
        drive_sequence(16'h0025);
        #20;
        
        // Test Case 2: "1234"
        $display("Test Case 2: 1234");
        drive_sequence(16'h1234);
        #20;
        
        // Test Case 3: "0000"
        $display("Test Case 3: 0000");
        drive_sequence(16'h0000);
        #20;
        
        // Test Case 4: "0020" (Expected: 0+0+2+0 = 2, even => odd=0)
        $display("Test Case 4: 0020");
        drive_sequence(16'h0020);
        #20;
        
        // Test Case 5: "0027" (Sequence fails at last digit; output 0)
        $display("Test Case 5: 0027");
        drive_sequence(16'h0027);
        #20;
        
        // Test Case 6: "0500" (Invalid transition; output 0)
        $display("Test Case 6: 0500");
        drive_sequence(16'h0500);
        #20;
        
        // Test Case 7: "0215" (Invalid sequence; output 0)
        $display("Test Case 7: 0215");
        drive_sequence(16'h0215);
        #20;
        
        // Test Case 8: "0045" (Invalid at s2 transition; output 0)
        $display("Test Case 8: 0045");
        drive_sequence(16'h0045);
        #20;
        
        // Test Case 9: "0005" (Does not complete valid sequence; output 0)
        $display("Test Case 9: 0005");
        drive_sequence(16'h0005);
        #20;
        
        // Test Case 10: "1357" (Random sequence; output depends on FSM transitions)
        $display("Test Case 10: 1357");
        drive_sequence(16'h1357);
        #20;
        
        $finish;
    end

endmodule