-- Author: Jonah Ebent
-- Define the 4-bit adder inputs and outputs
ENTITY adder4 IS
    PORT (
        A, B : IN bit_vector(3 DOWNTO 0);
        Ci : IN BIT;
        Sum : OUT bit_vector(3 DOWNTO 0);
        Cout : OUT BIT
    );
END ENTITY adder4;

-- Define the behavior of the 4-bit adder
ARCHITECTURE behavior OF adder4 IS
    -- Reference the previous definition of the full adder
    COMPONENT adder IS
        PORT (
            a, b : IN BIT;
            c_in : IN BIT;
            sum : OUT BIT;
            c_out : OUT BIT
        );
    END COMPONENT;
    -- Define the signals used internally in the 4-bit adder
    SIGNAL c0, c1, c2 : BIT;
BEGIN
    -- The carry input to the first adder is set to 0
    adder0 : adder
    PORT MAP(
        a => A(0),
        b => B(0),
        c_in => Ci,
        sum => Sum(0),
        c_out => c0
    );
    adder1 : adder
    PORT MAP(
        a => A(1),
        b => B(1),
        c_in => c0,
        sum => Sum(1),
        c_out => c1
    );
    adder2 : adder
    PORT MAP(
        a => A(2),
        b => B(2),
        c_in => c1,
        sum => Sum(2),
        c_out => c2
    );
    adder3 : adder
    PORT MAP(
        a => A(3),
        b => B(3),
        c_in => c2,
        sum => Sum(3),
        c_out => Cout
    );
END ARCHITECTURE behavior;