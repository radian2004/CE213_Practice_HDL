
module Lab3_Mealy(CLK, dataIn, RST, odd);
  // Input and Output Declarations
  input [3:0]  dataIn;
  input        CLK;
  input        RST;
  output       odd;

  // DataInternal Variables
  reg [3:0]  state;
  reg [3:0]  next_state;
  reg [4:0]  sumid;	

  // State Declarations (m?c dù state ch? dùng 3 bit, s? d?ng 4 bit cho nh?t quán)
  parameter reset = 3'b000;
  parameter s1    = 3'b001;
  parameter s2    = 3'b010;
  parameter s3    = 3'b011;

  // Combinational Next State Logic
  always @(*) begin
    case(state)
      reset: begin
        if (dataIn == 0) begin
          next_state = s1;
          sumid = sumid + dataIn;
        end
        else begin
          next_state = reset;
        end
      end
      s1: begin
        if (dataIn == 0) begin
          next_state = s2;
          sumid = sumid + dataIn;
        end
        else begin
          next_state = reset;
        end
      end
      s2: begin
        if (dataIn == 2) begin
          next_state = s3;
          sumid = sumid + dataIn;
        end
        else if (dataIn == 0) begin
          next_state = s2;
        end
        else begin
          next_state = reset;
        end
      end
      s3: begin
        if (dataIn == 5) begin
          next_state = reset;
          sumid = sumid + dataIn;
        end
        else if (dataIn == 0) begin
          next_state = s1;
        end
        else begin
          next_state = reset;
        end
      end
      default: begin
        next_state = reset;
      end
    endcase
  end

  // State FF Transition
  always @(posedge CLK) begin
    if (RST == 1)
      state <= reset;
    else
      state <= next_state;
  end

  // Combinational Output Logic
  assign odd = (state == s3 && dataIn == 5 && (sumid % 2 == 1)) ? 1 : 0;

endmodule // Mealy Student ID Detector
