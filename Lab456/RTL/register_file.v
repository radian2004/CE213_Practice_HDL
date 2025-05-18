module register_file
  (
   input wire        clk,
   input wire        reset_n,
   input wire [4:0]  read_reg1,
   input wire [4:0]  read_reg2,
   input wire [4:0]  write_reg,
   input wire [31:0] write_data,
   input wire        reg_write,
   output reg [31:0] read_data1,
   output reg [31:0] read_data2
   );

   reg [31:0] registers [0:31]; // 32 32-bit registers

   // Initialize register $zero to 0 and potentially others
   initial
     begin
        registers[0] = 32'b0;
        // You can initialize other registers here for testing if needed
        // e.g., registers[8] = 32'd10; // $t0 = 10
        // registers[9] = 32'd20; // $t1 = 20
     end

   // Write operation (on positive clock edge if RegWrite is asserted and write_reg is not $zero)
   always @(posedge clk)
     begin
        if (!reset_n)
          begin
             // Reset logic (optional, usually handled by initial block for $zero)
             registers[0] <= 32'b0;
             // For full reset:
             // for (int i = 1; i < 32; i = i + 1) begin
             //     registers[i] <= 32'b0;
             // end
          end
        else if (reg_write)
          begin
             // Prevent writing to register $zero (register 0)
             if (write_reg != 5'b00000)
               begin
                  registers[write_reg] <= write_data;
               end
          end
     end

   // Read operations (combinational logic)
   // Data is available immediately based on the read addresses
   always @(*)
     begin
        // Reading from register $zero always returns 0
        read_data1 = (read_reg1 == 5'b00000) ? 32'b0 : registers[read_reg1];
        read_data2 = (read_reg2 == 5'b00000) ? 32'b0 : registers[read_reg2];
     end

endmodule
