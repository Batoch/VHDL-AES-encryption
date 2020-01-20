library IEEE;
use IEEE.std_logic_1164.all;
--conversion de bit8 (std_logic_vector) en entier
use IEEE.numeric_std.all;
--pour l'utilisation du type byt8
library LIB_AES;
use LIB_AES.crypt_pack.all;

library LIB_RTL;

entity subbytes_tb is

end entity subbytes_tb;

architecture subbytes_tb_arch of subbytes_tb is
component subbytes
    port(
        data_i : in type_state;
        data_o : out type_state
    );
end component;

signal data_i_s : type_state;
signal data_o_s : type_state;

begin

DUT : subbytes port map
    (
        data_i => data_i_s,
        data_o => data_o_s
    );

--addroundkey 79 1b 66 62 47 8e b7 c8 8b 81 7c e4 65 aa 6f 03

data_i_s <= ((x"79",x"47",x"8b",x"65"),
             (x"1b",x"8e",x"81",x"aa"),
             (x"66",x"b7",x"7c",x"6f"),
             (x"62",x"c8",x"e4",x"03")) after 10 ns;

end subbytes_tb_arch ; -- shiftrow_arch

configuration subbytes_tb_conf of subbytes_tb is
    for subbytes_tb_arch
        for DUT : subbytes
            use entity LIB_RTL.subbytes(subbytes_arch);
        end for;
    end for;
end configuration subbytes_tb_conf;