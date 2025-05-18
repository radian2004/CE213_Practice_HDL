// sign_extend.v
module sign_extend
(
   input wire [15:0]  in,
   output wire [31:0] out
);
   // Replicate the sign bit (bit 15) 16 times and concatenate with the input
   assign out = {{16{in[15]}}, in};
endmodule
