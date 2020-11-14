-- Lembremo-nos que eh uma ROM (Read Only Memory) entao seus dados n mudam
-- Agora faremos leitura de arquivo!
library ieee;
use ieee.textio.all;
USE ieee.numeric_std.ALL;

entity rom_arquivo_generica is
  generic (
    addressSize : natural := 4 ;
    wordSize : natural := 8 ;
    datFileName : string := "rom.dat "
  );
  port (
addr : in bit_vector (addressSize-1 downto 0 ) ;
data : out bit_vector (wordSize-1 downto 0 )
  ) ;
end rom_arquivo ;

architecture rom_arch of rom_arquivo_generica is
    type tipo_mem is array (0 to (2**addressSize) - 1) of bit_vector (wordSize-1 downto 0); --declaracao do tipo "memoria"
    --declaracao da memoria e seu conteudo
    impure function inicializador(arquivo  : in string) return mem_t is
        file     arquivo  : text open read_mode is arquivo;
        variable linha    : line;
        variable conteudo_mem: bit_vector(wordSize-1 downto 0);
        variable memoria_arg : tipo_mem;
        begin
          for i in tipo_mem'range loop
            readline(arquivo, linha);
            read(linha, conteudo_mem);
            memoria_arg(i) := conteudo_mem;
          end loop;
          return memoria_arg;
        end;
      signal memoria : tipo_mem := inicializa(datFileName);
begin
    --Leitura
    data <= memoria(to_integer(unsigned(addr))); --entra o endereco(bin), eh considerado unsigned,
    --                                             vira numero, sai o dado no endereco

end architecture rom_arch;