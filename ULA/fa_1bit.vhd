-------------------------------------------------------
--! @file fa_1bit.vhd
--! @brief 1-bit full adder
--! @author Edson S. Gomi (gomi@usp.br)
--! @date 2020-10-20
-------------------------------------------------------
 
entity fulladder is
    port (
      a, b, cin: in bit;
      s, cout: out bit
    );
  end entity;
  -------------------------------------------------------
  architecture structural of fulladder is
    signal axorb: bit;
  begin
    axorb <= a xor b;
    s <= axorb xor cin;
    cout <= (axorb and cin) or (a and b);
  end architecture;