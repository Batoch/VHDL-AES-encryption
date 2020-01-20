library IEEE;
use IEEE.std_logic_1164.all;
--conversion de bit8 (std_logic_vector) en entier
use IEEE.numeric_std.all;
--pour l'utilisation du type byt8
library LIB_AES;
use LIB_AES.crypt_pack.all;

library LIB_RTL;

entity mixcolumns_tb is

end entity mixcolumns_tb;

architecture mixcolumns_tb_arch of mixcolumns_tb is
component mixcolumns
    port(
        data_i  : in type_state;
        mix_i   : in std_logic;
        data_o  : out type_state
    );
end component;

signal data_i_s : type_state;
signal mix_i_s  : std_logic;
signal data_o_s : type_state;

begin

DUT : mixcolumns port map
    (
        data_i => data_i_s,
        mix_i  => mix_i_s,
        data_o => data_o_s
    );

--data_i_s <= "af e6 01 d5 16 91 06 ab ce 62 d3 b1 bc 44 20 ae"

data_i_s <= ((x"af",x"16",x"ce",x"bc"),
             (x"e6",x"91",x"62",x"44"),
             (x"01",x"06",x"d3",x"20"),
             (x"d5",x"ab",x"b1",x"ae")) after 10 ns;

-- resultat attendu : a0 ae 2f bc 29 8e 6d e0 43 d5 d9 81 21 fa 51 fc

mix_i_s <= '1' after 20 ns;

end mixcolumns_tb_arch; -- mixcolumns_arch

configuration mixcolumns_tb_conf of mixcolumns_tb is
    for mixcolumns_tb_arch
        for DUT : mixcolumns
            use entity LIB_RTL.mixcolumns(mixcolumns_arch);
        end for;
    end for;
end configuration mixcolumns_tb_conf;