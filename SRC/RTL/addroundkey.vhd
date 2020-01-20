library IEEE;
use IEEE.std_logic_1164.all;
--conversion de bit8 (std_logic_vector) en entier
use IEEE.numeric_std.all;
--pour l'utilisation du type byt8
library LIB_AES;
use LIB_AES.crypt_pack.all;

entity addroundkey is
    port(
        data_i  : in type_state;
        key_i   : in type_state;
        data_o  : out type_state
    );
end entity addroundkey;


architecture addroundkey_arch of addroundkey is

begin -- addroundkey_arch

    lig : for i in 0 to 3 generate
        col : for j in 0 to 3 generate
            data_o(i)(j) <= data_i(i)(j) xor key_i(i)(j);
        end generate;
    end generate;

end architecture addroundkey_arch;
