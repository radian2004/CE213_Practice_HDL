
module control_unit
  (
   input wire [5:0] opcode,
   input wire [5:0] funct,      // Only needed for R-type (add)
   output reg       reg_dst,
   output reg       alu_src,
   output reg       mem_to_reg,
   output reg       reg_write,
   output reg       mem_read,
   output reg       mem_write,
   output reg [3:0] alu_control // Needs 4 bits based on common ALU control signals
   );

   // Define opcode values for the instructions we support
   localparam [5:0]
                   OPCODE_R_TYPE = 6'b000001,
                   OPCODE_LW     = 6'b000100,
                   OPCODE_SW     = 6'b000010;



   // Define funct field values for R-type instructions we support
   localparam [5:0] FUNCT_ADD =    6'b100000;


   // Define ALU Control values for the operations we need
   localparam [3:0] ALU_ADD   =    4'b0101; // Corresponds to add operation

   always @(*) begin
      // Default values (typically deasserted or a safe default)
      reg_dst     = 0;
      alu_src     = 0;
      mem_to_reg  = 0;
      reg_write   = 0;
      mem_read    = 0;
      mem_write   = 0;
      alu_control = 4'b0000; // Default ALU operation (e.g., AND or passthrough)

      case (opcode)
        OPCODE_R_TYPE:
          begin // R-type instructions
             reg_dst   = 1;     // Write to rd
             alu_src   = 0;     // Second ALU operand is RD2
             mem_to_reg= 0;     // Write ALU result to register
             reg_write = 1;     // Enable register write
             mem_read  = 0;
             mem_write = 0;
             // Determine ALUControl based on funct for R-type
             case (funct)
               FUNCT_ADD:
                 alu_control = ALU_ADD; // add
               // Add other supported R-type funct codes here
               default:
                 alu_control = 4'b0000; // Default/unsupported R-type func
             endcase
          end
        OPCODE_LW:
          begin // lw (Load Word)
             reg_dst   = 0;     // Write to rt
             alu_src   = 1;     // Second ALU operand is sign-extended immediate
             mem_to_reg= 1;     // Write data from memory to register
             reg_write = 1;     // Enable register write
             mem_read  = 1;     // Enable memory read
             mem_write = 0;
             alu_control = ALU_ADD; // ALU performs addition for address calculation
          end
        OPCODE_SW:
          begin // sw (Store Word)
             reg_dst   = 0;     // Doesn't matter, RegWrite is 0
             alu_src   = 1;     // Second ALU operand is sign-extended immediate
             mem_to_reg= 0;     // Doesn't matter, RegWrite is 0
             reg_write = 0;     // Disable register write
             mem_read  = 0;
             mem_write = 1;     // Enable memory write
             alu_control = ALU_ADD; // ALU performs addition for address calculation
          end
        default:
          begin // Handle unsupported opcodes
             // All control signals remain at their default (deasserted) values
             reg_dst   = 'bx;     // Doesn't matter, RegWrite is 0
             alu_src   = 'bx;     // Second ALU operand is sign-extended immediate
             mem_to_reg= 'bx;     // Doesn't matter, RegWrite is 0
             reg_write = 'bx;     // Disable register write
             mem_read  = 'bx;
             mem_write = 'bx;     // Enable memory write
             alu_control = 'bxxxx; // ALU performs addition for address calculation
        end
      endcase
   end
endmodule
