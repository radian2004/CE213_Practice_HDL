// instruction_memory_tb.v
// Testbench for the instruction_memory module

module instruction_memory_tb;

    // Declare inputs as registers
    reg [31:0] address; // Byte address input to instruction memory

    // Declare output as a wire
    wire [31:0] instruction; // Instruction output from instruction memory

    // Instantiate the Instruction Memory module under test
    // Make sure instruction_memory.v and instructions.txt are available
    instruction_memory dut (
        .address(address),
        .instruction(instruction)
    );

    // Test stimulus
    initial begin
        $display("Starting Instruction Memory Testbench...");

        // Initialize address
        address = 32'h0; // Start at byte address 0

        // Wait for initial values to propagate
        #10;

        $display("Time | Address | Instruction");
        $display("-----------------------------");

        // Read instructions at sequential word addresses
        // We increment the byte address by 4 for each instruction
        repeat (30) begin // Read the first 10 instructions from the file
            $display("%4d | %h    | %h", $time, address, instruction);
            address = address + 32'd4; // Move to the next word address
            #10; // Wait for the new address to propagate and output to update
        end

        // Read from a different address
        address = 32'h20; // Byte address 32 (word address 8)
        #10;
        $display("%4d | %h    | %h", $time, address, instruction);

        // Read from another address
        address = 32'h100; // Byte address 256 (word address 64)
        #10;
        $display("%4d | %h    | %h", $time, address, instruction);


        $display("-----------------------------");
        $display("Instruction Memory Testbench finished.");
        $finish; // End simulation
    end

endmodule
