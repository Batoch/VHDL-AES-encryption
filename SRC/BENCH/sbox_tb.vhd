library IEEE;
use IEEE.std_logic_1164.all;
--conversion de bit8 (std_logic_vector) en entier
use IEEE.numeric_std.all;
--pour l'utilisation du type byt8
library LIB_AES;
use LIB_AES.crypt_pack.all;

library LIB_RTL;

entity sbox_tb is

end entity sbox_tb;

architecture sbox_tb_arch of sbox_tb is
component sbox
    port(
        data_i : in bit8;
        data_o : out bit8
    );
end component;

signal data_i_s : bit8;
signal data_o_s : bit8;

begin

DUT : sbox port map
    (
        data_i => data_i_s,
        data_o => data_o_s
    );

data_i_s <= x"00", x"55" after 50 ns, x"AA" after 100 ns;
end sbox_tb_arch ; -- sbox_arch

configuration sbox_tb_conf of sbox_tb is
    for sbox_tb_arch
        for DUT : sbox
            use entity LIB_RTL.sbox(sbox_arch);
        end for;
    end for;
end configuration sbox_tb_conf;