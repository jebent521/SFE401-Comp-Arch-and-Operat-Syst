-- Editor: Jonah Ebent
entity mux is
    -- `a`, `b` and `s` are inputs of the multiplexer element.
    -- `C` is the output, 
    port (a, b : in bit; s : in bit; C : out bit );
end mux;

architecture rtl of mux is
begin
    --  This multiplexer architecture contains one concurrent assignment.
      
    C <= (a and not(s)) or (b and s);
    
end rtl;
  