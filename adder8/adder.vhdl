-- Author: Jonah Ebent
ENTITY adder IS
    -- `a`, `b`, and the carry-in `c_in` are inputs of the adder
    -- `sum` is the sum output, `c_out` is the carry-out.
    PORT (
        a, b : IN BIT;
        c_in : IN BIT;
        sum : OUT BIT;
        c_out : OUT BIT);
END adder;

ARCHITECTURE rt1 OF adder IS
BEGIN
    --  This full-adder architecture contains two concurrent assignments.
    --  Compute the sum.
    sum <= a XOR b XOR c_in;
    --  Compute the carry
    c_out <= (a AND b) OR (c_in AND (a XOR b));
END rt1;