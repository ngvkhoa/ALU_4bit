`timescale 1ns / 1ps

module ALU_4bit_tb;

    logic [3:0] A;
    logic [3:0] B;
    logic       SUB;

    logic [3:0] ARITH_out;
    logic       C_out;
    logic [3:0] AND_out;
    logic [3:0] OR_out;
    logic [3:0] XOR_out;

    ALU_4bit uut (.*);

    initial begin
        A = 4'd5;  B = 4'd3; SUB = 1'b0;
        #10;

        A = 4'd15; B = 4'd1; SUB = 1'b0;
        #10;

        A = 4'd7;  B = 4'd7; SUB = 1'b1;
        #10;

        A = 4'd9;  B = 4'd4; SUB = 1'b1;
        #10;

        A = 4'd3;  B = 4'd5; SUB = 1'b1;
        #10;

        $finish;
    end

endmodule
