`timescale 1ns/1ps

module Lab3_Moore(CLK, dataIn, RST, odd);
    input [3:0] dataIn;
    input       CLK;
    input       RST;
    output      odd;
    
    // Định nghĩa state là 3-bit để phù hợp với các mã trạng thái
    reg [2:0] state, next_state;
    reg [4:0] sumid, next_sumid;
    
    // Khai báo tham số trạng thái
    parameter RESET = 3'b000;
    parameter S1    = 3'b001;
    parameter S2    = 3'b010;
    parameter S3    = 3'b011;
    parameter S4    = 3'b100;
    
    // Logic tính toán trạng thái và sum tiếp theo (kết hợp)
    always @(*) begin
        // Gán mặc định: giữ nguyên trạng thái và tổng hiện tại
        next_state = state;
        next_sumid = sumid;
        case(state)
            RESET: begin
                if (dataIn == 0) begin
                    next_state = S1;
                    next_sumid = 0;
                end
                else begin
                    next_state = RESET;
                    next_sumid = 0;
                end
            end
            S1: begin
                if (dataIn == 0) begin
                    next_state = S2;
                    next_sumid = 0;
                end
                else begin
                    next_state = RESET;
                    next_sumid = 0;
                end
            end
            S2: begin
                if (dataIn == 2) begin
                    next_state = S3;
                    next_sumid = sumid + 2;
                end
                else if (dataIn == 0) begin
                    next_state = S2; // Giữ nguyên S2, không cập nhật sum
                    next_sumid = sumid;
                end
                else begin
                    next_state = RESET;
                    next_sumid = 0;
                end
            end
            S3: begin
                if (dataIn == 5) begin
                    next_state = S4;
                    next_sumid = sumid + 5;
                end
                else if (dataIn == 0) begin
                    next_state = S1;
                    next_sumid = sumid;
                end
                else begin
                    next_state = RESET;
                    next_sumid = 0;
                end
            end
            S4: begin
                if (dataIn == 0) begin
                    next_state = S1;
                    next_sumid = sumid;
                end
                else begin
                    next_state = RESET;
                    next_sumid = 0;
                end
            end
            default: begin
                next_state = RESET;
                next_sumid = 0;
            end
        endcase
    end

    // Cập nhật các thanh ghi state và sumid theo đồng bộ (có reset đồng bộ)
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            state <= RESET;
            sumid <= 0;
        end
        else begin
            state <= next_state;
            sumid <= next_sumid;
        end
    end

    // Logic xuất: odd = 1 nếu ở trạng thái S4 và sumid lẻ, ngược lại = 0
    assign odd = ((state == S4) && ((sumid % 2) == 1)) ? 1 : 0;

endmodule