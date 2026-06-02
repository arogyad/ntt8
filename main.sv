module ntt8_top (
    input  logic       clk,
    input  logic       rst,
    input  logic       start,
    input  logic [4:0] in_data [0:7],
    output logic       done,
    output logic [4:0] out_data [0:7]
);
    typedef enum logic [1:0] {IDLE, RUN, FINISH} state_t;
    state_t state;

    logic [4:0] mem [0:7];

    logic [1:0] stage;
    logic [1:0] group;
    logic [1:0] j;

    logic [2:0] addr_a;
    logic [2:0] addr_b;

    logic [4:0] a_val;
    logic [4:0] b_val;
    logic [4:0] w;
    logic [4:0] u;
    logic [4:0] v;

    int i;

    function automatic [2:0] bitrev3(input [2:0] x);
        return {x[0], x[1], x[2]};
    endfunction

    twiddle_rom tw_rom (
        .stage(stage),
        .j(j),
        .w(w)
    );

    butterfly bfly (
        .a(a_val),
        .b(b_val),
        .w(w),
        .u(u),
        .v(v)
    );


    always_comb begin
        case (stage)
            2'd0: begin
                addr_a = {group, 1'b0};
                addr_b = addr_a + 3'd1;
            end

            2'd1: begin
                addr_a = {group[0], 2'b00} + j;
                addr_b = addr_a + 3'd2;
            end

            2'd2: begin
                addr_a = j;
                addr_b = j + 3'd4;

            end

            default: begin
                addr_a = 3'd0;
                addr_b = 3'd0;
            end
        endcase
    end

    always_comb begin
        a_val = mem[addr_a];
        b_val = mem[addr_b];
    end

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            done  <= 1'b0;
            stage <= 2'd0;
            group <= 2'd0;
            j     <= 2'd0;

            for (i = 0; i < 8; i = i + 1) begin
                mem[i]      <= 5'd0;
                out_data[i] <= 5'd0;
            end
        end 
        else begin
            case (state)

                IDLE: begin
                    done <= 1'b0;

                    if (start) begin
                        for (i = 0; i < 8; i = i + 1) begin
                            mem[i] <= in_data[bitrev3(i[2:0])];
                        end

                        stage <= 2'd0;
                        group <= 2'd0;
                        j     <= 2'd0;

                        state <= RUN;
                    end
                end

                RUN: begin
                    mem[addr_a] <= u;
                    mem[addr_b] <= v;

                    case (stage)

                        2'd0: begin
                            if (group == 2'd3) begin
                                stage <= 2'd1;
                                group <= 2'd0;
                                j     <= 2'd0;
                                $display("Stage 1:");
                                for (i = 0; i < 8; i = i + 1) begin
                                    $display("out[%0d] = %0d", i, mem[i]);
                                end
                            end 
                            else begin
                                group <= group + 2'd1;
                            end
                        end

                        2'd1: begin
                            if (j == 2'd1) begin
                                if (group == 2'd1) begin
                                    stage <= 2'd2;
                                    group <= 2'd0;
                                    j     <= 2'd0;
                                    $display("Stage 2:");
                                    for (i = 0; i < 8; i = i + 1) begin
                                        $display("out[%0d] = %0d", i, mem[i]);
                                    end
                                end 
                                else begin
                                    group <= group + 2'd1;
                                    j     <= 2'd0;
                                end
                            end 
                            else begin
                                j <= j + 2'd1;
                            end
                        end

                        2'd2: begin
                            if (j == 2'd3) begin
                                state <= FINISH;
                            end 
                            else begin
                                j <= j + 2'd1;
                            end
                        end

                        default: begin
                            state <= IDLE;
                        end
                    endcase
                end

                FINISH: begin
                    for (i = 0; i < 8; i = i + 1) begin
                        out_data[i] <= mem[i];
                    end

                    done  <= 1'b1;
                    state <= IDLE;
                end

                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end 
endmodule