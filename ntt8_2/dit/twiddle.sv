module twiddle #(
    parameter int LOG_N = 3,
    parameter int WIDTH = 5
)(
    input  logic [LOG_N - 1:0] stage,
    input  logic [LOG_N - 1:0] j,
    output logic [WIDTH - 1:0] w
);

   always_comb begin
        case (stage)
            3'd0: begin
                w = WIDTH'(1); 
            end
            3'd1: begin
                case (j)
                    3'd0: w = WIDTH'(1);
                    3'd1: w = WIDTH'(13);
                    default: w = WIDTH'(1);
                endcase
            end
            3'd2: begin
                case (j)
                    3'd0: w = WIDTH'(1);
                    3'd1: w = WIDTH'(9);
                    3'd2: w = WIDTH'(13);
                    3'd3: w = WIDTH'(15);
                    default: w = WIDTH'(1);
                endcase
            end
            default: w = WIDTH'(1);
        endcase
    end 

endmodule
