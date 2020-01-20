library IEEE;
use IEEE.std_logic_1164.all;
--conversion de bit8 (std_logic_vector) en entier
use IEEE.numeric_std.all;
--pour l'utilisation du type byt8
library LIB_AES;
use LIB_AES.crypt_pack.all;

entity shiftrow is
    port(
        data_i : in type_state;
        data_o : out type_state
    );
end entity shiftrow;

architecture shiftrow_arch of shiftrow is


begin -- shiftrow_arch

    data_o(0) <= (data_i(0)(0),data_i(0)(1),data_i(0)(2),data_i(0)(3));
    data_o(1) <= (data_i(1)(1),data_i(1)(2),data_i(1)(3),data_i(1)(0));
    data_o(2) <= (data_i(2)(2),data_i(2)(3),data_i(2)(0),data_i(2)(1));
    data_o(3) <= (data_i(3)(3),data_i(3)(0),data_i(3)(1),data_i(3)(2));

end architecture shiftrow_arch;