module ALU_4bit (
    input logic [3:0] A,
    input logic [3:0] B,
    input logic       SUB,
    
    output logic [3:0] ARITH_out,
    output logic       C_out,

    output logic [3:0] AND_out,
    output logic [3:0] OR_out,
    output logic [3:0] XOR_out
);

    logic [3:0] B_inv;
    logic       C4;
    
    always_comb begin
        B_inv = B ^ {4{SUB}};
        {C4, ARITH_out} = A + B_inv + SUB;
        C_out = C4 ^ SUB;
        
        AND_out = A & B;
        OR_out = A | B;
        XOR_out = A ^ B;
    end

endmodule
