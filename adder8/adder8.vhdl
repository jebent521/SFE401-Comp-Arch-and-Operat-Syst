-- Author: Jonah Ebent
ENTITY adder8 IS
  -- `A`, `B`, and the carry-in `Ci` are inputs of the adder.
  -- `Sum` is the sum output, `Cout` is the carry-out bit from the operation.
  PORT (
    A, B : IN BIT_VECTOR(7 DOWNTO 0);
    Ci : IN BIT;
    Sum : OUT BIT_VECTOR(7 DOWNTO 0);
    Cout : OUT BIT);
END adder8;
-- Define the behavior of the 8-bit adder
ARCHITECTURE BEHAVIORAL OF adder8 IS
  -- Reference the previous definition of the full adder
  COMPONENT adder4 IS
    PORT (
      A, B : IN BIT_VECTOR(3 DOWNTO 0);
      Ci : IN BIT;
      Sum : OUT BIT_VECTOR(3 DOWNTO 0);
      Cout : OUT BIT
    );
  END COMPONENT;
  -- Define the signals used internally in the 4-bit adder
  SIGNAL carry : BIT;
BEGIN
  -- The carry input to the first adder is set to 0
  adder0 : adder4
  PORT MAP(
    A => A(3 DOWNTO 0),
    B => B(3 DOWNTO 0),
    Ci => Ci,
    sum => Sum(3 DOWNTO 0),
    Cout => carry
  );
  adder1 : adder4
  PORT MAP(
    A => A(7 DOWNTO 4),
    B => B(7 DOWNTO 4),
    Ci => carry,
    Sum => Sum(7 DOWNTO 4),
    Cout => Cout
  );
END ARCHITECTURE BEHAVIORAL;