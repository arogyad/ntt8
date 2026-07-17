module test;

    parameter logic [3:0] N = 4'd8;
    parameter logic [2:0] WIDTH = 3'd5;

    logic clk;
    logic rst;
    logic ntt_start;
    logic intt_start;
    logic ntt_done;
    logic intt_done;
    
    logic [WIDTH - 1:0] in_data [0:N - 1];
    logic [WIDTH - 1:0] ntt_out_data [0:N - 1];
    logic [WIDTH - 1:0] out_data [0:N - 1];
    // logic [WIDTH - 1:0] expected [0:N - 1];

    ntt_top #(
        .N(N),
        .LOG_N(3'd3),
        .WIDTH(WIDTH)
    ) dut (
        .clk(clk),
        .rst(rst),
        .start(ntt_start),
        .in_data(in_data),
        .done(ntt_done),
        .out_data(ntt_out_data)
    );

    intt_top #(
        .N(N),
        .LOG_N(3'd3),
        .WIDTH(WIDTH)
    ) i_dut (
        .clk(clk),
        .rst(rst),
        .start(intt_start),
        .in_data(ntt_out_data),
        .done(intt_done),
        .out_data(out_data)
    );


    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1;
        ntt_start = 0;

        $readmemh("input.mem", in_data);
        // $readmemh("expected.mem", expected);

        #20;
        rst = 0;
        
        #10;
        ntt_start = 1;
        #10;
        ntt_start = 0;

        wait(ntt_done == 1'b1);
        
        #10;

        intt_start = 0;

        #10;
        intt_start = 1;
        #10;
        intt_start = 0;

        wait(intt_done == 1'b1);
        #10;

    //    for (int i = 0; i < 8; i = i + 1) begin
    //         if (out_data[i] !== expected[i]) begin
    //             $display("Mismatch at index %0d: got %0d expected %0d", i, out_data[i], expected[i]);
    //             $fatal;
    //         end
    //     end

    //     $display("PASS");
        for (int i = 0; i < 8; i = i + 1) begin
            $display("out[%0d] = %0h", i, out_data[i]);
        end 

        $finish;
    end
endmodule
