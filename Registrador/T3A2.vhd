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
    
    processo_associacao: process(clock, reset)
        begin
            if (clock'event and clock = '1') then
                if (regWrite = '1' and (to_integer(unsigned (wr)) /= regn - 1)) then
                    entrada(to_integer(unsigned (wr)) <= d;
                    load(to_integer(unsigned(addressIN))) <= '1';
                elsif (regWrite = '0') then
                    load <= (others=>'0');
                end if;
            end if;
    end process processo_associacao;

    q1 <= saida(to_integer(unsigned(addressOUT_1)));
    q2 <= saida(to_integer(unsigned(addressOUT_2)));



end architecture arch_regfile;
