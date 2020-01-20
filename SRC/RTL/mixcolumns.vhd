library IEEE;
use IEEE.std_logic_1164.all;
--conversion de bit8 (std_logic_vector) en entier
use IEEE.numeric_std.all;
--pour l'utilisation du type byt8
library LIB_AES;
use LIB_AES.crypt_pack.all;


entity mixcolumns is
    port(
        data_i      : in type_state;
        mix_i       : in std_logic;
        data_o      : out type_state
    );
end entity mixcolumns;

architecture mixcolumns_arch of mixcolumns is

    signal data_s   : type_state;

begin -- mixcolumns_arch

    colonne : for i in 0 to 3 generate
        data_s(0)(i) <= (fois2(data_i(0)(i))) XOR (fois3(data_i(1)(i))) XOR (data_i(2)(i)) XOR (data_i(3)(i));
        data_s(1)(i) <= data_i(0)(i) XOR fois2(data_i(1)(i)) XOR fois3(data_i(2)(i)) XOR data_i(3)(i);
        data_s(2)(i) <= data_i(0)(i) XOR data_i(1)(i) XOR fois2(data_i(2)(i)) XOR fois3(data_i(3)(i));
        data_s(3)(i) <= fois3(data_i(0)(i)) XOR data_i(1)(i) XOR data_i(2)(i) XOR fois2(data_i(3)(i));
    end generate colonne;
    
    data_o <= data_i when mix_i = '0' else data_s;


end architecture mixcolumns_arch;