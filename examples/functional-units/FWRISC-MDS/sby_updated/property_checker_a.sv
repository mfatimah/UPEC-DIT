// For operand a, the proof holds as the design timing does not depend on it but not for NOP operation.

module property_checker (

  input clk,
  input rst,

  input [31:0]  in_a1, in_a2,
  input [31:0]  in_b,
  input [3:0]   op,
  input         in_valid,
  output [31:0] out1, out2,
  output        out_valid1, out_valid2
);
  fwrisc_mul_div_shift_miter uut
  (
    .clk       (clk       ),
    .rst       (rst       ),
    .in_a1     (in_a1     ),
    .in_a2     (in_a2     ),
    .in_b1     (in_b      ),
    .in_b2     (in_b      ),
    .op1       (op        ),
    .op2       (op        ),
    .in_valid1 (in_valid  ),
    .in_valid2 (in_valid  ),
    .out1      (out1      ),
    .out2      (out2      ),
    .out_valid1(out_valid1),
    .out_valid2(out_valid2)
  );

    `ifdef FORMAL
      reg initial_clock_cycle;
      initial initial_clock_cycle <= 0;

      always @(posedge clk) begin
        initial_clock_cycle <= 1;
        if (!initial_clock_cycle) assume (rst);
        if (initial_clock_cycle) 
        assume (
                (op == 4'b0000) || // SLL
                (op == 4'b0001) || // SRL
                (op == 4'b0010) || // SRA
                (op == 4'b0011) || // MUL
                (op == 4'b0100) || // MULH
                (op == 4'b0101) || // MULS
                (op == 4'b0110) || // MULSH
                (op == 4'b0111) || // DIV
                (op == 4'b1000)    // REM
                //(op >= 4'b1001)    // NOP
        );
        if (!rst) assert (out_valid1 == out_valid2);
        end
    `endif
    
endmodule
