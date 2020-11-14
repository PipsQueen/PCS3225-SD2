-------------------------------------------------------
--! @file multiplicador.vhd
--! @brief synchronous multiplier
--! @author Edson Midorikawa (emidorik@usp.br)
--! @date 2020-06-15
-------------------------------------------------------

entity zero_detector is
  port (
    A    : in  bit_vector(3 downto 0);
    zero : out bit
    );
end entity;

architecture dataflow of zero_detector is
-- solution using a NOR gate
begin

  ZERO <= not(A(0) or A(1) or A(2) or A(3));
  
end architecture;

entity fa_1bit is
  port (
    A,B : in bit;       -- adends
    CIN : in bit;       -- carry-in
    SUM : out bit;      -- sum
    COUT : out bit      -- carry-out
    );
end entity fa_1bit;

architecture wakerly of fa_1bit is
-- Solution Wakerly's Book (4th Edition, page 475)
begin
  SUM <= (A xor B) xor CIN;
  COUT <= (A and B) or (CIN and A) or (CIN and B);
end architecture wakerly;

entity fa_4bit is
  port (
    A,B : in bit_vector(3 downto 0);    -- adends
    CIN : in bit;                       -- carry-in
    SUM : out bit_vector(3 downto 0);   -- sum
    COUT : out bit                      -- carry-out
    );
end entity fa_4bit;

architecture ripple of fa_4bit is
-- Ripple adder solution

  --  Declaration of the 1 bit adder.  
  component fa_1bit
    port (
      A,B : in bit;       -- adends
      CIN : in bit;       -- carry-in
      SUM : out bit;      -- sum
      COUT : out bit      -- carry-out
    );
  end component fa_1bit;

  signal x,y :   bit_vector(3 downto 0);
  signal s :     bit_vector(3 downto 0);
  signal cin0 :  bit;
  signal cin1 :  bit;
  signal cin2 :  bit;
  signal cin3 :  bit;
  signal cout0 : bit;  
  signal cout1 : bit;
  signal cout2 : bit;
  signal cout3 : bit;
  
begin
  
  -- Components instantiation
  ADDER0: entity work.fa_1bit(wakerly) port map (
    A => x(0),
    B => y(0),
    CIN => cin0,
    SUM => s(0),
    COUT => cout0
    );

  ADDER1: entity work.fa_1bit(wakerly) port map (
    A => x(1),
    B => y(1),
    CIN => cout0,
    SUM => s(1),
    COUT => cout1
    );

  ADDER2: entity work.fa_1bit(wakerly) port map (
    A => x(2),
    B => y(2),
    CIN => cout1,
    SUM => s(2),
    COUT => cout2
    );  

  ADDER3: entity work.fa_1bit(wakerly) port map (
    A => x(3),
    B => y(3),
    CIN => cout2,
    SUM => s(3),
    COUT => cout3
    );

  x <= A;
  y <= B;
  cin0 <= CIN;
  SUM <= s;
  COUT <= cout3;
  
end architecture ripple;

entity fa_8bit is
  port (
    A,B  : in  bit_vector(7 downto 0);
    CIN  : in  bit;
    SUM  : out bit_vector(7 downto 0);
    COUT : out bit
    );
end entity;

architecture ripple of fa_8bit is
-- Ripple adder solution

  --  Declaration of the 1-bit adder.  
  component fa_1bit
    port (
      A, B : in  bit;   -- adends
      CIN  : in  bit;   -- carry-in
      SUM  : out bit;   -- sum
      COUT : out bit    -- carry-out
    );
  end component fa_1bit;

  signal x,y :   bit_vector(7 downto 0);
  signal s :     bit_vector(7 downto 0);
  signal cin0 :  bit;
  signal cout0 : bit;  
  signal cout1 : bit;
  signal cout2 : bit;
  signal cout3 : bit;
  signal cout4 : bit;  
  signal cout5 : bit;
  signal cout6 : bit;
  signal cout7 : bit;
  
begin
  
  -- Components instantiation
  ADDER0: entity work.fa_1bit(wakerly) port map (
    A => x(0),
    B => y(0),
    CIN => cin0,
    SUM => s(0),
    COUT => cout0
    );

  ADDER1: entity work.fa_1bit(wakerly) port map (
    A => x(1),
    B => y(1),
    CIN => cout0,
    SUM => s(1),
    COUT => cout1
    );

  ADDER2: entity work.fa_1bit(wakerly) port map (
    A => x(2),
    B => y(2),
    CIN => cout1,
    SUM => s(2),
    COUT => cout2
    );  

  ADDER3: entity work.fa_1bit(wakerly) port map (
    A => x(3),
    B => y(3),
    CIN => cout2,
    SUM => s(3),
    COUT => cout3
    );

  ADDER4: entity work.fa_1bit(wakerly) port map (
    A => x(4),
    B => y(4),
    CIN => cout3,
    SUM => s(4),
    COUT => cout4
    );

  ADDER5: entity work.fa_1bit(wakerly) port map (
    A => x(5),
    B => y(5),
    CIN => cout4,
    SUM => s(5),
    COUT => cout5
    );

  ADDER6: entity work.fa_1bit(wakerly) port map (
    A => x(6),
    B => y(6),
    CIN => cout5,
    SUM => s(6),
    COUT => cout6
    );  

  ADDER7: entity work.fa_1bit(wakerly) port map (
    A => x(7),
    B => y(7),
    CIN => cout6,
    SUM => s(7),
    COUT => cout7
    );

  x <= A;
  y <= B;
  cin0 <= CIN;
  SUM <= s;
  COUT <= cout7;
  
end architecture ripple;

entity fa_inverter_4 is
  port (
    A     : in bit_vector(3 downto 0);
    EN    : in bit;
    A_inv : out bit_vector(3 downto 0)
  );
end entity fa_inverter_4;

architecture ripple of fa_inverter_4 is
  component fa_4bit
    port (
      A,B  : in  bit_vector(3 downto 0);
      CIN  : in  bit;
      SUM  : out bit_vector(3 downto 0);
      COUT : out bit
    );
  end component;

  signal A_comp1 : bit_vector(3 downto 0);
  signal A_inv_mid : bit_vector (3 downto 0);
begin
  --A_comp1 <= (not A(3)) & (not A(2)) & (not A(1)) & (not A(0));
  A_comp1 <= not A;
  COMP2: fa_4bit port map (
        A=>   A_comp1,
        B=>   "0001",  -- (+1)
        CIN=> '0',
        SUM=> A_inv_mid,
        COUT=> open
        );


  with EN select
    A_inv <= A_inv_mid when '1',
             A when '0',
             "0000" when others;
end architecture ripple;

entity fa_inverter_8 is
  port (
    A     : in bit_vector(7 downto 0);
    EN    : in bit;
    A_inv : out bit_vector(7 downto 0)
  );
end entity fa_inverter_8;

architecture ripple of fa_inverter_8 is
  component fa_8bit
    port (
      A,B  : in  bit_vector(7 downto 0);
      CIN  : in  bit;
      SUM  : out bit_vector(7 downto 0);
      COUT : out bit
      );
  end component;
  signal A_comp1 : bit_vector(7 downto 0);
  signal A_inv_mid : bit_vector(7 downto 0);
begin
  A_comp1 <= (not A(7)) & (not A(6)) & (not A(5)) & (not A(4)) & (not A(3)) & (not A(2)) & (not A(1)) & (not A(0));
  COMP2: fa_8bit port map (
        A=>   A_comp1,
        B=>   "00000001",  -- (+1)
        CIN=> '0',
        SUM=> A_inv_mid,
        COUT=> open
        );

  with EN select
    A_inv <= A_inv_mid when '1',
             A when '0',
             "00000000" when others;
end architecture ripple;

library ieee;
--use ieee.numeric_bit.rising_edge;

entity reg4 is
  port (
    clock, reset, enable: in bit;
    D: in  bit_vector(3 downto 0);
    Q: out bit_vector(3 downto 0)
  );
end entity;

architecture arch_reg4 of reg4 is
  signal dado: bit_vector(3 downto 0);
begin
  process(clock, reset)
  begin
    if reset = '1' then
      dado <= (others=>'0');
--    elsif (rising_edge(clock)) then
    elsif (clock'event and clock='1') then
      if enable='1' then
        dado <= D;
      end if;
    end if;
  end process;
  Q <= dado;
end architecture;

library ieee;
--use ieee.numeric_bit.rising_edge;

entity reg8 is
  port (
    clock, reset, enable: in bit;
    D: in  bit_vector(7 downto 0);
    Q: out bit_vector(7 downto 0)
  );
end entity;

architecture arch_reg8 of reg8 is
  signal dado: bit_vector(7 downto 0);
begin
  process(clock, reset)
  begin
    if reset = '1' then
      dado <= (others=>'0');
--    elsif (rising_edge(clock)) then
    elsif (clock'event and clock='1') then
      if enable='1' then
        dado <= D;
      end if;
    end if;
  end process;
  Q <= dado;
end architecture;

entity mux4_2to1 is
  port (
    SEL : in bit;    
    A :   in bit_vector  (3 downto 0);
    B :   in bit_vector  (3 downto 0);
    Y :   out bit_vector (3 downto 0)
    );
end entity mux4_2to1;

architecture with_select of mux4_2to1 is
begin
  with SEL select
    Y <= A when '0',
         B when '1',
         "0000" when others;
end architecture with_select;

library ieee;
--use ieee.numeric_bit.rising_edge;

entity multiplicador_uc is
  port (
    clock:    in bit;
    reset:    in bit;
    start:    in  bit;
    Zrb:      in  bit;
    RSTa,CEa: out bit;
    RSTb,CEb: out bit;
    RSTr,CEr: out bit;
    DCb:      out bit;
    ready:    out bit
  );
end entity;

architecture fsm of multiplicador_uc is
  type state_t is (wait0, x1, x2, fins);
  signal next_state, current_state: state_t;
begin
  fsm: process(clock, reset)
  begin
    if reset='1' then
      current_state <= wait0;
--    elsif (rising_edge(clock)) then
    elsif (clock'event and clock='1') then
      current_state <= next_state;
    end if;
  end process;

  -- Logica de proximo estado
  next_state <=
    wait0 when (current_state = wait0) and (start = '0') else
    x1    when (current_state = wait0) and (start = '1') else
    x2    when (current_state = x1)    and (zrb = '0') else
    fins  when (current_state = x1)    and (zrb = '1') else
    x2    when (current_state = x2)    and (zrb = '0') else
    fins  when (current_state = x2)    and (zrb = '1') else
    wait0 when (current_state = fins) else
    wait0;
	  
  -- Decodifica o estado para gerar sinais de controle
  CEa  <= '1' when current_state=x1 else '0';
  RSTa <= '1' when current_state=wait0 else '0';
  CEb  <= '1' when current_state=x1 or current_state=x2 else '0';
  RSTb <= '1' when current_state=wait0 else '0';
  CEr  <= '1' when current_state=x1 or current_state=x2 else '0';
  RSTr <= '1' when current_state=x1 else '0';
  DCb  <= '1' when current_state=x2 else '0';

  -- Decodifica o estado para gerar as saídas da UC
  Ready <= '1' when current_state=fins else '0';

end architecture;


entity multiplicador_fd is
  port (
    clock:    in  bit;
    Va,Vb:    in  bit_vector(3 downto 0);
    RSTa,CEa: in  bit;
    RSTb,CEb: in  bit;
    RSTr,CEr: in  bit;
    DCb:      in  bit;
    sig_mult_fd: in bit; --Entrada adicional, EP.
    Zrb:      out bit;
    Vresult:  out bit_vector(7 downto 0)
  );
end entity;

architecture structural of multiplicador_fd is

  component reg4
    port (
      clock, reset, enable: in bit;
      D: in  bit_vector(3 downto 0);
      Q: out bit_vector(3 downto 0)
    );
  end component;

  component reg8
    port (
      clock, reset, enable: in bit;
      D: in  bit_vector(7 downto 0);
      Q: out bit_vector(7 downto 0)
    );
  end component;

  component mux4_2to1
    port (
      SEL : in bit;    
      A :   in bit_vector  (3 downto 0);
      B :   in bit_vector  (3 downto 0);
      Y :   out bit_vector (3 downto 0)
    );
  end component;

  component fa_4bit
    port (
      A,B  : in  bit_vector(3 downto 0);
      CIN  : in  bit;
      SUM  : out bit_vector(3 downto 0);
      COUT : out bit
    );
  end component;

  component fa_8bit
    port (
      A,B  : in  bit_vector(7 downto 0);
      CIN  : in  bit;
      SUM  : out bit_vector(7 downto 0);
      COUT : out bit
      );
  end component;

  component zero_detector
    port (
      A    : in bit_vector(3 downto 0);
      zero : out bit
    );
  end component;

  --New!
  component fa_inverter_4
    port (
      A     : in bit_vector(3 downto 0);
      EN    : in bit;
      A_inv : out bit_vector(3 downto 0)
    );
  end component;
  --New!
  component fa_inverter_8
    port (
      A     : in bit_vector(7 downto 0);
      EN    : in bit;
      A_inv : out bit_vector(7 downto 0)
    );
  end component;

  signal mag_Va, mag_Vb:     bit_vector(3 downto 0); --New!
  signal sigdif, sigA, sigB: bit; --New!
  signal s_ra, s_rb:         bit_vector(3 downto 0);
  signal s_bmenos1, s_muxb:  bit_vector(3 downto 0);
  signal s_a8, s_soma, s_rr: bit_vector(7 downto 0);
  signal s_rr_signed:        bit_vector(7 downto 0); --New!
  
begin
  sigdif <= sig_mult_fd and ((Va(3) xor Vb(3)));
  sigA <= (sig_mult_fd and Va(3));
  sigB <= (sig_mult_fd and Vb(3));
  MAG_A: fa_inverter_4 port map(
    A =>   Va,
    EN => sigA,
    A_inv => mag_Va
    );
  MAG_B: fa_inverter_4 port map(
    A =>   Vb,
    EN => sigB,
    A_inv => mag_Vb
    );
  SIGN_RESULT: fa_inverter_8 port map(
    A=> s_rr,
    EN => sigdif,
    A_inv => s_rr_signed
    );

  
  RA: reg4 port map (
      clock=>  clock, 
      reset=>  RSTa, 
      enable=> CEa,
      D=>      mag_Va,
      Q=>      s_ra
     );
  
  RB: reg4 port map (
      clock=>  clock, 
      reset=>  RSTb, 
      enable=> CEb,
      D=>      s_muxb,
      Q=>      s_rb
     );
  
  RR: reg8 port map (
      clock=>  clock, 
      reset=>  RSTr, 
      enable=> CEr,
      D=>      s_soma,
      Q=>      s_rr
     );  
  
  SOMA: fa_8bit port map (
        A=>   s_a8,
        B=>   s_rr,
        CIN=> '0',
        SUM=> s_soma,
        COUT=> open
        );

  SUB1: fa_4bit port map (
        A=>   s_rb,
        B=>   "1111",  -- (-1)
        CIN=> '0',
        SUM=> s_bmenos1,
        COUT=> open
        );
  
  MUXB: mux4_2to1 port map (
        SEL=> DCb,    
        A=>   mag_Vb,
        B=>   s_bmenos1,
        Y=>   s_muxb
        );

  ZERO: zero_detector port map (
        A=>    s_rb,
        zero=> Zrb
        );

  
  s_a8 <= "0000" & s_ra;
  Vresult <= s_rr_signed;
  
end architecture;

library ieee;
--use ieee.numeric_bit.rising_edge;

entity multiplicador is
  port (
    Clock:    in  bit;
    Reset:    in  bit;
    Start:    in  bit;
    Va,Vb:    in  bit_vector(3 downto 0);
    Vresult:  out bit_vector(7 downto 0);
    Ready:    out bit;
    sig_mult: in bit --test!
  );
end entity;

architecture structural of multiplicador is

  component multiplicador_uc
    port (
      clock:    in  bit;
      reset:    in  bit;
      start:    in  bit;
      Zrb:      in  bit;
      RSTa,CEa: out bit;
      RSTb,CEb: out bit;
      RSTr,CEr: out bit;
      DCb:      out bit;
      ready:    out bit
    );
  end component;

  component multiplicador_fd
    port (
      clock:    in  bit;
      Va,Vb:    in  bit_vector(3 downto 0);
      RSTa,CEa: in  bit;
      RSTb,CEb: in  bit;
      RSTr,CEr: in  bit;
      DCb:      in  bit;
      sig_mult_fd: in bit; --teste!
      Zrb:      out bit;
      Vresult:  out bit_vector(7 downto 0)
      
    );
  end component;

  signal s_zrb:          bit;
  signal s_rsta, s_cea:  bit;
  signal s_rstb, s_ceb:  bit;
  signal s_rstr, s_cer:  bit;
  signal s_dcb:          bit;

  signal s_clock_n:      bit;

begin
  
  s_clock_n <= not Clock;

  MULT_UC: multiplicador_uc port map (
      clock=> Clock,
      reset=> Reset,
      start=> Start,
      Zrb =>  s_zrb,
      RSTa=>  s_rsta,
      CEa=>   s_cea,
      RSTb=>  s_rstb,
      CEb=>   s_ceb,
      RSTr=>  s_rstr,
      CEr=>   s_cer,
      DCb=>   s_dcb,
      ready=> Ready
    );

  -- FD usa sinal invertido
  MULT_FD: multiplicador_fd port map (
      clock=>    s_clock_n,
      Va=>       Va,
      Vb=>       Vb,
      RSTa=>     s_rsta,
      CEa=>      s_cea,
      RSTb=>     s_rstb,
      CEb=>      s_ceb,
      RSTr=>     s_rstr,
      CEr=>      s_cer,
      DCb=>      s_dcb,
      Zrb =>     s_zrb,
      Vresult => Vresult,
      sig_mult_fd => sig_mult --teste!
    );
  
end architecture;

