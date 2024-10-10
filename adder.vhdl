entity adder is
    -- `a`, `b`, and the carry-in `c_in` are inputs of the adder
    -- `sum` is the sum output, `c_out` is the carry-out.
    port (a, b : in bit; c_in : in bit; sum : out bit; c_out : out bit);
end adder;

architecture rt1 of adder is
begin
    --  This full-adder architecture contains two concurrent assignments.
    --  Compute the sum.
    sum <= a xor b xor c_in;
    --  Compute the carry
    c_out <= (a and b) or (c_in and (a xor b));
end rt1;