`timescale 1ns / 1ps

module ALU_4bit_tb;

    reg  [3:0] A;
    reg  [3:0] B;
    reg        SUB;

    wire [3:0] ARITH_out;
    wire       C_out;
    wire [3:0] AND_out;
    wire [3:0] OR_out;
    wire [3:0] XOR_out;

    integer errors = 0;

    ALU_4bit uut (
        .A(A),
        .B(B),
        .SUB(SUB),
        .ARITH_out(ARITH_out),
        .C_out(C_out),
        .AND_out(AND_out),
        .OR_out(OR_out),
        .XOR_out(XOR_out)
    );

    task check_results(
        input [3:0] exp_arith,
        input       exp_cout,
        input [3:0] exp_and,
        input [3:0] exp_or,
        input [3:0] exp_xor,
        input [80*8:1] test_name
    );
    begin
        #10;
        if (ARITH_out !== exp_arith || C_out !== exp_cout || 
            AND_out !== exp_and     || OR_out !== exp_or  || XOR_out !== exp_xor) 
        begin
            $display("[FAIL] %0s | A=%b B=%b SUB=%b | OUTPUT: ARITH=%b Cout=%b | EXPECT: ARITH=%b Cout=%b", 
                     test_name, A, B, SUB, ARITH_out, C_out, exp_arith, exp_cout);
            errors = errors + 1;
        end else begin
            $display("[PASS] %0s | ARITH=%h Cout=%b AND=%h OR=%h XOR=%h", 
                     test_name, ARITH_out, C_out, AND_out, OR_out, XOR_out);
        end
    end
    endtask

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, ALU_4bit_tb);

        $display("____TESTING PROCESS BEGIN____");

        A = 4'd5; B = 4'd3; SUB = 1'b0;
        check_results(4'd8, 1'b0, (5 & 3), (5 | 3), (5 ^ 3), "TEST 1: 5 + 3");

        A = 4'd15; B = 4'd1; SUB = 1'b0;
        check_results(4'd0, 1'b1, (15 & 1), (15 | 1), (15 ^ 1), "TEST 2: 15 + 1");

        A = 4'd7; B = 4'd7; SUB = 1'b1;
        check_results(4'd0, 1'b0, (7 & 7), (7 | 7), (7 ^ 7), "TEST 3: 7 - 7");

        A = 4'd9; B = 4'd4; SUB = 1'b1;
        check_results(4'd5, 1'b0, (9 & 4), (9 | 4), (9 ^ 4), "TEST 4: 9 - 4");
        
        A = 4'd3; B = 4'd5; SUB = 1'b1;
        check_results(4'b1110, 1'b1, (3 & 5), (3 | 5), (3 ^ 5), "TEST 5: 3 - 5");

        $display("========================================");
        if (errors == 0)
            $display("PASS ALL TESTCASES");
        else
            $display("FIND %0d ERRORS", errors);
        $display("========================================");

        $finish;
    end

endmodule