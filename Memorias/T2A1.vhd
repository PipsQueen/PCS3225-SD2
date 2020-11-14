-- Lembremo-nos que eh uma ROM (Read Only Memory) entao seus dados n mudam
library ieee;
USE ieee.numeric_std.ALL;

entity rom_simples is
port (
addr : in bit_vector (3 downto 0 ) ;
data : out bit_vector (7 downto 0 )
) ;
end rom_simples ;

architecture rom_arch of rom_simples is
    type tipo_mem is array (0 to 15) of bit_vector (7 downto 0); --declaracao do tipo "memoria"
    --declaracao da memoria e seu conteudo
    signal memoria : tipo_mem := ("00000000", "00000011", "11000000", "00001100", "00110000", "01010101", "10101010", "11111111", "11100000", "11100111", "00000111", "00011000", "11000011", "00111100", "11110000", "00001111");
begin
    --Leitura
    data <= memoria(to_integer(unsigned(addr))); --entra o endereco(bin), eh considerado unsigned,
    --                                             vira numero, sai o dado no endereco

end architecture rom_arch;