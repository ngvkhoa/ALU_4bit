module ALU_4bit (
    input wire [3:0] A,
    input wire [3:0] B,
    input wire       SUB,

    output wire [3:0] ARITH_out,
    output wire       C_out,

    output wire [3:0] AND_out,
    output wire [3:0] OR_out,
    output wire [3:0] XOR_out
);

    wire [3:0] B_inv;
    assign B_inv = B ^ {4{SUB}};
    
    // Arithmetic operations
    wire C4;
    assign {C4, ARITH_out} = A + B_inv + SUB;
    assign C_out = C4 ^ SUB;

    // Logic operations
    assign AND_out = A & B;
    assign OR_out  = A | B;
    assign XOR_out = A ^ B;

endmodule 