module alu
  (
   input wire [31:0] operand1,
   input wire [31:0] operand2,
   input wire [3:0]  alu_control,
   output reg [31:0] result,
   output wire       zero
   );

   // Define ALU Control values (should match control_unit defines)
   localparam [3:0]
                   COMPLEMENT = 4'b0000,
                   AND = 4'b0001,
                   XOR = 4'b0010,
                   OR  = 4'b0011,
                   DEC = 4'b0100,
                   ADD = 4'b0101,
                   SUB = 4'b0110,
                   INC = 4'b0111;

   assign zero = (result == 32'b0);

   always @(*)
     begin
        case (alu_control)
          COMPLEMENT:
            result = ~operand1;
          AND:
            result = operand1 & operand2;
          XOR:
            result = operand1 ^ operand2;
          OR:
            result = operand1 | operand2;
          DEC:
            result = operand1 - 32'd1;
          ADD:
            result = operand1 + operand2; // Addition
          SUB:
            result = operand1 - operand2;
          INC:
            result = operand1 + 32'd1;
          default:  result = 32'b0; // Default or unsupported operation
        endcase
     end
endmodule
