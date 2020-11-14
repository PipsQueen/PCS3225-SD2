library ieee;
USE ieee.numeric_std.ALL;

entity ram is
    generic (
    addressSize : natural := 4;
    wordSize : natural := 8
    ) ;
    port (
    ck , wr : in bit ;
    addr : in bit_vector ( addressSize −1 downto 0 ) ;
    data_i : in bit_vector ( wordSize −1 downto 0 ) ;
    data_o : out bit_vector ( wordSize −1 downto 0 )
    ) ;
end ram ;

architecture ram_arch of ram is
    type tipo_mem is array (0 to (2**addressSize) - 1) of bit_vector (wordSize-1 downto 0); --declaracao do tipo "memoria"

    signal memoria : tipo_mem;
begin
    process(ck)
    begin
        if (ck'event and ck = '1') then
            if wr = '1' then 
                memoria(to_integer(unsigned(addr))) <= data_1;
            end if;
        end if;
    end process;
    
    data_o <= memoria(to_integer(unsigned(addr)));
end architecture ram_arch;