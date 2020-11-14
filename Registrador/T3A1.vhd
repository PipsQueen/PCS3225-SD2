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