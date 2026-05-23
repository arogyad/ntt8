module twiddle_rom (
    input  logic [1:0] stage,
    input  logic [1:0] j,
    output logic [4:0] w
);
    always_comb  begin
        case (stage)
            2'd0: begin
                w = 5'd1;
            end

            2'd1: begin
                case (j)
                    2'd0: w = 5'd1;
                    2'd1: w = 5'd13;
                    default: w = 5'd1;
                endcase
            end

            2'd2: begin
                case (j)
                    2'd0: w = 5'd1;
                    2'd1: w = 5'd9;
                    2'd2: w = 5'd13;
                    2'd3: w = 5'd15;
                    default: w = 5'd1;
                endcase
            end

            default: begin
                w = 5'd1;
            end
        endcase
    end
endmodule