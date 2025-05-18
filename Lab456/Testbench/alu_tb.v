`timescale 1ns/1ps
module alu_tb;

   // Declare inputs as registers
   reg [31:0] operand1;
   reg [31:0] operand2;
   reg [3:0]  alu_control; // Control signal for ALU operation

   // Declare outputs as wires
   wire [31:0] result;
   wire        zero; // Includes the zero output

   integer     i;


   // Instantiate the ALU module under test
   // Make sure alu.v is in the same directory or included in your project
   alu dut (
            .operand1    (operand1),
            .operand2    (operand2),
            .alu_control (alu_control),
            .result      (result),
            .zero        (zero) // Connect the zero output
            );

   // Define ALU Control values (must match alu.v localparams)
   localparam [3:0]
                   COMPLEMENT = 4'b0000,
                   AND        = 4'b0001,
                   XOR        = 4'b0010,
                   OR         = 4'b0011,
                   DEC        = 4'b0100,
                   ADD        = 4'b0101,
                   SUB        = 4'b0110,
                   INC        = 4'b0111;

   // Memory to hold test case data read from the file
   // Each entry is 68 bits: [67:36] for operand1, [35:4] for operand2, [3:0] for alu_control
   reg [67:0]      test_cases [0:9]; // Assuming up to 100 test cases

   // Define a task to apply inputs from a test case entry and wait
   task apply_test_case;
      input [67:0] test_data;
      begin
         // Extract inputs from the test data entry
         operand1    = test_data[67:36];
         operand2    = test_data[35:4];
         alu_control = test_data[3:0];

         // Wait for the combinatorial logic to settle
         #10;
      end
   endtask

   // Define a task to verify the ALU result for the current inputs
   task verify_alu_result;
      input [31:0] actual_result;
      input        actual_zero;
      reg [31:0]   expected_result;
      reg          expected_zero;
      reg          test_passed;

      begin
         test_passed = 1; // Assume pass initially

         // Calculate the expected result based on the current alu_control
         case (alu_control)
           COMPLEMENT: expected_result = ~operand1;
           AND:        expected_result = operand1 & operand2;
           XOR:        expected_result = operand1 ^ operand2;
           OR:         expected_result = operand1 | operand2;
           DEC:        expected_result = operand1 - 32'd1;
           ADD:        expected_result = operand1 + operand2;
           SUB:        expected_result = operand1 - operand2;
           INC:        expected_result = operand1 + 32'd1;
           default:    expected_result = 32'b0; // Match default in ALU
         endcase

         // Calculate the expected zero flag
         expected_zero = (expected_result == 32'b0);

         // Compare actual vs. expected
         if (actual_result !== expected_result) begin
            $display("    FAILED: Result mismatch!");
            // Print operation name using case
            case (alu_control)
              COMPLEMENT: $display("        Operation: COMPLEMENT (Ctrl %b)", alu_control);
              AND:        $display("        Operation: AND (Ctrl %b)", alu_control);
              XOR:        $display("        Operation: XOR (Ctrl %b)", alu_control);
              OR:         $display("        Operation: OR (Ctrl %b)", alu_control);
              DEC:        $display("        Operation: DEC (Ctrl %b)", alu_control);
              ADD:        $display("        Operation: ADD (Ctrl %b)", alu_control);
              SUB:        $display("        Operation: SUB (Ctrl %b)", alu_control);
              INC:        $display("        Operation: INC (Ctrl %b)", alu_control);
              default:    $display("        Operation: DEFAULT (Ctrl %b)", alu_control);
            endcase
            $display("        Inputs: Op1=%h (%d), Op2=%h (%d)", operand1, $signed(operand1), operand2, $signed(operand2));
            $display("        Actual Result: %h (%d)", actual_result, $signed(actual_result));
            $display("        Expected Result: %h (%d)", expected_result, $signed(expected_result));
            test_passed = 0;
         end

         else if (actual_zero !== expected_zero) begin
            $display("    FAILED: Zero flag mismatch!");
            // Print operation name using case
            case (alu_control)
              COMPLEMENT: $display("        Operation: COMPLEMENT (Ctrl %b)", alu_control);
              AND:        $display("        Operation: AND (Ctrl %b)", alu_control);
              XOR:        $display("        Operation: XOR (Ctrl %b)", alu_control);
              OR:         $display("        Operation: OR (Ctrl %b)", alu_control);
              DEC:        $display("        Operation: DEC (Ctrl %b)", alu_control);
              ADD:        $display("        Operation: ADD (Ctrl %b)", alu_control);
              SUB:        $display("        Operation: SUB (Ctrl %b)", alu_control);
              INC:        $display("        Operation: INC (Ctrl %b)", alu_control);
              default:    $display("        Operation: DEFAULT (Ctrl %b)", alu_control);
            endcase
            $display("        Inputs: Op1=%h (%d), Op2=%h (%d)", operand1, $signed(operand1), operand2, $signed(operand2));
            $display("        Actual Zero: %b, Expected Zero: %b", actual_zero, expected_zero);
            test_passed = 0;
         end

         else
           begin
              // Use $write followed by $display with case to print PASSED line
              $write("    PASSED: ");
              case (alu_control)
                COMPLEMENT: $display("COMPLEMENT (Ctrl %b) - Op1=%h, Op2=%h -> Res=%h, Zero=%b", alu_control, operand1, operand2, actual_result, actual_zero);
                AND:        $display("AND (Ctrl %b) - Op1=%h, Op2=%h -> Res=%h, Zero=%b", alu_control, operand1, operand2, actual_result, actual_zero);
                XOR:        $display("XOR (Ctrl %b) - Op1=%h, Op2=%h -> Res=%h, Zero=%b", alu_control, operand1, operand2, actual_result, actual_zero);
                OR:         $display("OR (Ctrl %b) - Op1=%h, Op2=%h -> Res=%h, Zero=%b", alu_control, operand1, operand2, actual_result, actual_zero);
                DEC:        $display("DEC (Ctrl %b) - Op1=%h, Op2=%h -> Res=%h, Zero=%b", alu_control, operand1, operand2, actual_result, actual_zero);
                ADD:        $display("ADD (Ctrl %b) - Op1=%h, Op2=%h -> Res=%h, Zero=%b", alu_control, operand1, operand2, actual_result, actual_zero);
                SUB:        $display("SUB (Ctrl %b) - Op1=%h, Op2=%h -> Res=%h, Zero=%b", alu_control, operand1, operand2, actual_result, actual_zero);
                INC:        $display("INC (Ctrl %b) - Op1=%h, Op2=%h -> Res=%h, Zero=%b", alu_control, operand1, operand2, actual_result, actual_zero);
                default:    $display("DEFAULT (Ctrl %b) - Op1=%h, Op2=%h -> Res=%h, Zero=%b", alu_control, operand1, operand2, actual_result, actual_zero);
              endcase
           end
      end
   endtask


   // Test stimulus
   initial begin
      $display("Starting ALU Testbench (reading from file)...");

      // Read test cases from the external file
      // Each line in the file should contain 3 hex values: operand1, operand2, alu_control
      // We read them into a 68-bit memory entry: [67:36] op1, [35:4] op2, [3:0] ctrl
      $readmemh("/home/lamar/quartus/HDL/lab/lab456/alu_testcases.txt", test_cases);
      $display("Test cases loaded from alu_testcases.txt");

      // Initialize inputs to a known state
      operand1 = 32'h0;
      operand2 = 32'h0;
      alu_control = 4'b1111; // Set to an unsupported control initially
      #10; // Wait for initial values

      $display("--- Executing Test Cases from File ---");

      // Determine the number of test cases read (assuming file has fewer than 100 lines)
      // A more robust way would be to count lines or use a marker in the file
      // For simplicity, we'll loop up to 100 or until $readmemh stopped filling
      for (i = 0; i < 10; i = i + 1) begin
         // Check if this memory location was filled by $readmemh
         // $readmemh stops filling if it reaches end of file or fills the memory
         // We can check if the entry is still its initial value (e.g., 'x' or 0)
         // A more reliable method might involve a count in the file or a specific end marker
         // For this example, we'll assume 100 is the max and the file has fewer.
         // If test_cases[i] is all zeros, it might be a valid test case (0+0=0, etc.)
         // A better check is needed for real systems. For this example, we'll just loop 100 times.

         // Apply the inputs for the current test case and wait
         apply_test_case(test_cases[i]);

         // Verify the result for the current test case
         verify_alu_result(result, zero);

         // Optional: Add a small delay between test cases if needed for clarity
         // #5;
      end


      $display("ALU Testbench finished.");
      $finish; // End simulation
   end

endmodule
