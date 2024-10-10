-- Author: Jonah Ebent
ENTITY adder8_tb IS
END adder8_tb;

ARCHITECTURE behavior OF adder8_tb IS
    --  Declaration of the component that will be instantiated.
    COMPONENT adder8
        PORT (
            A, B : IN bit_vector(7 DOWNTO 0);
            Ci : IN BIT;
            Sum : OUT bit_vector(7 DOWNTO 0);
            Cout : OUT BIT);
    END COMPONENT;

    --  Specifies which entity is bound with the component.
    FOR adder_0 : adder8 USE ENTITY work.adder8;
    SIGNAL A, B, Sum : bit_vector(7 DOWNTO 0);
    SIGNAL Ci, Cout : BIT;
BEGIN
    --  Component instantiation.
    adder_0 : adder8 PORT MAP(A => A, B => B, Ci => Ci, Sum => Sum, Cout => Cout);

    --  This process does the real job.
    PROCESS
        TYPE pattern_type IS RECORD
            --  The inputs of the adder.
            A, B : bit_vector(7 DOWNTO 0);
            Ci : BIT;
            --  The expected outputs of the adder.
            Sum : bit_vector(7 DOWNTO 0);
            Cout : BIT;
        END RECORD;
        --  The patterns to apply.
        TYPE pattern_array IS ARRAY (NATURAL RANGE <>) OF pattern_type;
        CONSTANT patterns : pattern_array :=
        ((B"00000001", B"00000001", '0', B"00000010", '0'),
        (B"11111111", B"00000001", '0', B"00000000", '1'),
        (B"00000001", B"11111111", '0', B"00000000", '1'),
        (B"00001111", B"11110000", '1', B"00000000", '1'));
    BEGIN
        --  Check each pattern.
        FOR i IN patterns'RANGE LOOP
            --  Set the inputs.
            A <= patterns(i).A;
            B <= patterns(i).B;
            Ci <= patterns(i).Ci;
            --  Wait for the results.
            WAIT FOR 1 ns;
            --  Check the outputs.
            ASSERT Sum = patterns(i).Sum
            REPORT "bad sum value" SEVERITY error;
            ASSERT Cout = patterns(i).Cout
            REPORT "bad carry out value" SEVERITY error;
        END LOOP;
        ASSERT false REPORT "end of test" SEVERITY note;
        --  Wait forever; this will finish the simulation.
        WAIT;
    END PROCESS;

END behavior;