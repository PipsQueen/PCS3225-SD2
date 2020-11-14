-- Lembremo-nos que eh uma ROM (Read Only Memory) entao seus dados n mudam
-- Agora faremos leitura de arquivo!
library ieee;
use ieee.textio.all;
USE ieee.numeric_std.ALL;

entity rom_arquivo is
port (
addr : in bit_vector (3 downto 0 ) ;
data : out bit_vector (7 downto 0 )
) ;
end rom_arquivo ;

architecture rom_arch of rom_arquivo is
    type tipo_mem is array (0 to 15) of bit_vector (7 downto 0); --declaracao do tipo "memoria"
    --declaracao da memoria e seu conteudo
    impure function inicializador(arquivo  : in string) return mem_t is
        file     arquivo  : text open read_mode is arquivo;
        variable linha    : line;
        variable conteudo_mem: bit_vector(7 downto 0);
        variable memoria_arg : tipo_mem;
        begin
          for i in tipo_mem'range loop
            readline(arquivo, linha);
            read(linha, conteudo_mem);
            memoria_arg(i) := conteudo_mem;
          end loop;
          return memoria_arg;
        end;
      signal memoria : tipo_mem := inicializa("conteudo_rom_ativ_02_carga.dat");
begin
    --Leitura
    data <= memoria(to_integer(unsigned(addr))); --entra o endereco(bin), eh considerado unsigned,
    --                                             vira numero, sai o dado no endereco

end architecture rom_arch;