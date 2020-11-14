-------------------------------------------------------------------------------------------------------------------
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-------------------------------------------------------------------------------------------------------------------

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

