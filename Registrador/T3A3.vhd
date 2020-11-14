--Somador 1 bit
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

--Somador 5 bit
entity fa_5bit is
    port (
      A,B : in bit_vector(4 downto 0);    -- adends
      CIN : in bit;                       -- carry-in
      SUM : out bit_vector(4 downto 0);   -- sum
      COUT : out bit                      -- carry-out
      );
  end entity fa_5bit;
  
  architecture ripple of fa_5bit is
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
  
    signal x,y :   bit_vector(4 downto 0);
    signal s :     bit_vector(4 downto 0);
    signal cin0 :  bit;
    signal cin1 :  bit;
    signal cin2 :  bit;
    signal cin3 :  bit;
    signal cout0 : bit;  
    signal cout1 : bit;
    signal cout2 : bit;
    signal cout3 : bit;
    signal cout4 : bit;
    
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
    x <= A;
    y <= B;
    cin0 <= CIN;
    SUM <= s;
    COUT <= cout4;
    
end architecture ripple;
  
--Inversor 5 bit
entity fa_inverter_5 is
    port (
      A     : in bit_vector(4 downto 0);
      EN    : in bit;
      A_inv : out bit_vector(4 downto 0)
    );
  end entity fa_inverter_5;
  
  architecture ripple of fa_inverter_5 is
    component fa_5bit
      port (
        A,B  : in  bit_vector(4 downto 0);
        CIN  : in  bit;
        SUM  : out bit_vector(4 downto 0);
        COUT : out bit
      );
    end component;
  
    signal A_comp1 : bit_vector(4 downto 0);
    signal A_inv_mid : bit_vector (4 downto 0);
  begin
    A_comp1 <= not(A) ;
    --A_comp1 <= not(A);
    COMP2: fa_5bit port map (
          A=>   A_comp1,
          B=>   "00000",  
          CIN=> '1', -- (+1)
          SUM=> A_inv_mid,
          COUT=> open
          );
    with EN select
      A_inv <= A_inv_mid when '1',
               A when '0' ;
end architecture ripple;

--Somador 8 bit
entity fa_8bit is
    port (
      A,B  : in  bit_vector(7 downto 0);
      CIN  : in  bit;
      SUM  : out bit_vector(7 downto 0);
      COUT : out bit;
      OVF  : out bit
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
    OVF <= cout7 xor cout6;
    
end architecture ripple;

--Somador 16bit
entity fa_16bit is
    port (
        A,B  : in  bit_vector(15 downto 0);
        CIN  : in  bit;
        SUM  : out bit_vector(15 downto 0);
        COUT : out bit;
        OVF  : out bit
        );
  end entity;

  architecture concatenation of fa_16bit is
    component fa_8bit
      port (
        A,B  : in  bit_vector(7 downto 0);
        CIN  : in  bit;
        SUM  : out bit_vector(7 downto 0);
        COUT : out bit;
        OVF  : out bit
      );
    end component fa_8bit;
    signal a_firsthalf, b_firsthalf : bit_vector (7 downto 0);
    signal a_secndhalf, b_secndhalf : bit_vector (7 downto 0);
    signal mid_cout : bit;
    signal s_firsthalf, s_secndhalf : bit_vector(7 downto 0);
  begin
    a_firsthalf <= A(7) & A(6) & A(5) & A(4) & A(3) & A(2) & A(1) & A(0);
    b_firsthalf <= B(7) & B(6) & B(5) & B(4) & B(3) & B(2) & B(1) & B(0); 
    a_secndhalf <= A(15) & A(14) & A(13) & A(12) & A(11) & A(10) & A(9) & A(8);
    b_secndhalf <= B(15) & B(14) & B(13) & B(12) & B(11) & B(10) & B(9) & B(8);
    ADDER_FirstHalf : fa_8bit port map (a_firsthalf, b_firsthalf,   '0'   , s_firsthalf, mid_cout, open);
    ADDER_SecndHalf : fa_8bit port map (a_secndhalf, b_secndhalf, mid_cout, s_secndhalf, COUT, OVF);
    SUM <= s_secndhalf & s_firsthalf;
end architecture concatenation;

--Inversor 16bit
entity fa_inverter_16 is
    port (
        A : in bit_vector(15 downto 0);
        EN: in bit;
        A_inv : out bit_vector(15 downto 0)
    );
  end entity fa_inverter_16;

  architecture ripple of fa_inverter_16 is
    component fa_16bit
    port(
        A,B  : in  bit_vector(15 downto 0);
        CIN  : in  bit;
        SUM  : out bit_vector(15 downto 0);
        COUT : out bit;
        OVF  : out bit
    );
    end component;
    signal A_comp1 : bit_vector(15 downto 0);
    signal A_inv_mid : bit_vector (15 downto 0);
  begin
    a_comp1 <= not(A);
    
    COMP2 : fa_16bit port map(
        a_comp1, 
        "0000000000000001", 
        '0', 
        a_inv_mid, 
        open,
        open
    );
    with EN select
        A_inv <= A_inv_mid when '1',
        A when '0';

    
end architecture ripple;


--Registrador
entity reg is
    generic(wordSize: natural := 4);
    port(
        clock: in  bit; ---! entrada de clock
        reset: in  bit; ---! clear assincrono
        load:  in  bit; ---! write enable (carga paralela)
        d:     in  bit_vector (wordSize-1 downto 0); ---! entrada
        q:     out bit_vector (wordSize-1 downto 0) ---! saida
  );
  end reg;

  architecture arch_reg of reg is
    signal inside_data : bit_vector (wordsize-1 downto 0);
  begin
    process_registrador: process(clock, reset)
    begin
        if reset = '1' then
            inside_data <= (others=>'0');
        elsif (clock'event and clock = '1') then
            if (load = '1') then
                inside_data <= d;
            end if;
        end if;
    end process;
    q <= inside_data;   
end architecture arch_reg;





library IEEE;
use IEEE.numeric_bit.all;
use IEEE.math_real.ceil;
use IEEE.math_real.log2;

--Banco de Registradores
entity regfile is
    generic(
        regn: natural := 32;
        wordSize: natural := 64
    );
    port (
        clock:        in  bit;
        reset:        in  bit;
        regWrite:     in  bit;
        rr1, rr2, wr: in  bit_vector(natural(ceil(log2(real(regn))))-1 downto 0);    
        d:            in  bit_vector(wordSize-1 downto 0);
        q1, q2:       out bit_vector(wordSize-1 downto 0)
    );
  end entity regfile;

  architecture arch_regfile of regfile is

    component reg
        generic(wordsize: natural := 4);
        port(
                clock: in  bit;
                reset: in  bit;
                load:  in  bit;
                d:     in  bit_vector(wordsize-1 downto 0);
                q:     out bit_vector(wordsize-1 downto 0)
            );
    end component;
    type endereco_palavra is array (0 to regn) of bit_vector(wordSize-1 downto 0);
    type endereco_bit is array (0 to regn) of bit;

    signal addressIN, addressOUT_1, addressOUT_2 : bit_vector(natural(ceil(log2(real(regn))))-1 downto 0);
    signal entrada, saida : endereco_palavra := (others=>(others=>'0'));
    signal load : endereco_bit := (others=>'0');
  begin
    reg_generator: for i in 0 to regn-1 generate
        reg_i: reg generic map(wordSize) port map(clock, reset, load(i), entrada(i), saida(i));
    end generate reg_generator;
    addressIN <= wr;
    addressOUT_1 <= rr1;
    addressOUT_2 <= rr2;
    entrada(to_integer(unsigned(addressIN))) <= d;
    load(to_integer(unsigned(addressIN))) <= '1' when (regWrite = '1' and (to_integer(unsigned (wr)) /= (regn - 1))) else '0';
    --processo_associacao: process(clock, reset)
    --    begin
    --        if (clock'event and clock = '1') then
    --            if (regWrite = '1' and (to_integer(unsigned (wr)) /= (regn - 1))) then
    --                load(to_integer(unsigned(addressIN))) <= '1'; --Tirar do sincrono
    --            elsif (regWrite = '0') then
    --                load <= (others=>'0'); --Tirar do sincrono
    --            end if;
    --        end if;
    --end process processo_associacao;

    q1 <= saida(to_integer(unsigned(addressOUT_1)));
    q2 <= saida(to_integer(unsigned(addressOUT_2)));



end architecture arch_regfile;

library ieee;
use IEEE.numeric_bit.all;
use IEEE.math_real.ceil;
use IEEE.math_real.log2;

--Calculadora
entity calc is
    port (
        clock : in bit;
        reset : in bit;
        instruction : in bit_vector(15 downto 0);
        overflow : out bit;
        q1 : out bit_vector (15 downto 0)
    );
end entity calc;

architecture arch_calc of calc is
    constant ADD : bit := '1';
    constant ADDI: bit := '0';

    component regfile
        generic(
            regn: natural := 32;
            wordSize: natural := 64
        );
        port (
            clock:        in  bit;
            reset:        in  bit;
            regWrite:     in  bit;
            rr1, rr2, wr: in  bit_vector(natural(ceil(log2(real(regn))))-1 downto 0);    
            d:            in  bit_vector(wordSize-1 downto 0);
            q1, q2:       out bit_vector(wordSize-1 downto 0)
        );
    end component;

    component fa_inverter_5
        port (
        A     : in bit_vector(4 downto 0);
        EN    : in bit;
        A_inv : out bit_vector(4 downto 0)
        );
    end component;

    component fa_16bit
        port (
            A,B  : in  bit_vector(15 downto 0);
            CIN  : in  bit;
            SUM  : out bit_vector(15 downto 0);
            COUT : out bit;
            OVF  : out bit
            );
    end component;

    component fa_inverter_16
        port (
            A : in bit_vector(15 downto 0);
            EN: in bit;
            A_inv : out bit_vector(15 downto 0)
        );
    end component;
    --- INSTRUCTION    = |(opcod)|(oper2)|(oper1)|(desti)|
    --- SIZE (15 bits) = | 1 bit | 5 bit | 5 bit | 5 bit |
    signal opcode : bit;
    signal oper1, oper2 : bit_vector (4 downto 0);
    signal dest : bit_vector (4 downto 0);


    signal numA, numB, Sum : bit_vector (15 downto 0);
    signal cout : bit;
    
    signal mag_02            : bit_vector (4 downto 0);
    signal oper_16, value_16 : bit_vector (15 downto 0);

    signal endout1, endout2    : bit_vector (4 downto 0); 
    signal entrada, out1, out2 : bit_vector (15 downto 0);

    signal to_invert : bit;


    type endereco_palavra is array (0 to 31) of bit_vector(15 downto 0);
    type endereco_bit is array (0 to 31) of bit;

    --signal memoria : endereco_palavra := (others=>(others=>'0'));
begin
    regBank : regfile  generic map (32, 16) port map  (clock, reset, '1' , endout1, endout2, dest, entrada, out1, out2);
    somador : fa_16bit port map (numA, numB, '0', Sum, cout, overflow);
    inv_I_16: fa_inverter_16 port map(oper_16, to_invert, value_16);
    inv_I_05: fa_inverter_5 port map(oper2, to_invert, mag_02);
    to_invert <= (not opcode) and oper2(4);
    
    opcode <= instruction(15);
    oper2  <= instruction(14 downto 10);
    oper1  <= instruction(9 downto 5);
    dest   <= instruction(4 downto 0);
    entrada <= sum;
    
    oper_16<= "00000000000" & mag_02;

    endout1 <= oper1;
    endout2 <= oper2;
    

    numA    <= out1; 
    numB    <= out2 when opcode = ADD else value_16;

    q1 <= out1;
    --overflow <= cout and (numA(14) and numB(14));
end architecture arch_calc;