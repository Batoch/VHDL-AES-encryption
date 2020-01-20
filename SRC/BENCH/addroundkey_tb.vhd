library IEEE;
use IEEE.std_logic_1164.all;
--conversion de bit8 (std_logic_vector) en entier
use IEEE.numeric_std.all;
--pour l'utilisation du type byt8
library LIB_AES;
use LIB_AES.crypt_pack.all;

library LIB_RTL;

entity addroundkey_tb is

end entity addroundkey_tb;

architecture addroundkey_tb_arch of addroundkey_tb is
component addroundkey
    port(
        data_i  : in type_state;
        key_i   : in type_state;
        data_o  : out type_state
    );
end component;

signal data_i_s : type_state;
signal key_i_s  : type_state;
signal data_o_s : type_state;

begin

DUT : addroundkey port map
    (
        data_i => data_i_s,
        key_i  => key_i_s,
        data_o => data_o_s
    );

--MixColumns : a0 ae 2f bc 29 8e 6d e0 43 d5 d9 81 21 fa 51 fc

data_i_s <= ((x"a0",x"29",x"43",x"21"),
             (x"ae",x"8e",x"d5",x"fa"),
             (x"2f",x"6d",x"d9",x"51"),
             (x"bc",x"e0",x"81",x"fc")) after 10 ns;

--key : 75 ec 78 56 5d 42 aa f0 f6 b5 bf 78 ff 7a f0 44
key_i_s <= ((x"75",x"5d",x"f6",x"ff"),
            (x"ec",x"42",x"b5",x"7a"),
            (x"78",x"aa",x"bf",x"f0"),
            (x"56",x"f0",x"78",x"44")) after 10 ns;

end addroundkey_tb_arch ; -- addroundkey_arch

configuration addroundkey_tb_conf of addroundkey_tb is
    for addroundkey_tb_arch
        for DUT : addroundkey
            use entity LIB_RTL.addroundkey(addroundkey_arch);
        end for;
    end for;
end configuration addroundkey_tb_conf;