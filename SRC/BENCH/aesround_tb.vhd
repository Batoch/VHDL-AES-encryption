library IEEE;
use IEEE.std_logic_1164.all;
--conversion de bit8 (std_logic_vector) en entier
use IEEE.numeric_std.all;
--pour l'utilisation du type byt8
library LIB_AES;
use LIB_AES.crypt_pack.all;

library LIB_RTL;

entity aesround_tb is

end entity aesround_tb;

architecture aesround_tb_arch of aesround_tb is
component aesround
    port(
        data_i              : in bit128;
        current_key_i       : in bit128;
        clock_i             : in std_logic;
        mixcolumns_en_i     : in std_logic;
        reset_i             : in std_logic;
        sel_i               : in std_logic;

        data_o              : out bit128
    );
end component;

signal data_i_s             : bit128;
signal current_key_i_s      : bit128;
signal clock_i_s            : std_logic := '0';
signal mixcolumns_en_i_s    : std_logic := '0';
signal reset_i_s            : std_logic := '1';
signal sel_i_s              : std_logic := '1';

signal data_o_s             : bit128;


begin

DUT : aesround port map
    (
        data_i          => data_i_s,
        current_key_i   => current_key_i_s,
        clock_i         => clock_i_s,
        mixcolumns_en_i => mixcolumns_en_i_s,
        reset_i         => reset_i_s,
        sel_i           => sel_i_s,

        data_o          => data_o_s
    );

    clock_i_s <= not clock_i_s after 25 ns;

    PROCESS BEGIN


    --Init:
    -- InitKey : 2b 7e 15 16 28 ae d2 a6 ab f7 15 88 09 cf 4f 3c
    -- SetPlaintext : 52 65 73 74 6f 20 65 6e 20 76 69 6c 6c 65 20 3f
    -- AddRoundKey : 79 1b 66 62 47 8e b7 c8 8b 81 7c e4 65 aa 6f 03
    data_i_s        <= X"526573746f20656e2076696c6c65203f";
    current_key_i_s <= X"2b7e151628aed2a6abf7158809cf4f3c";

    WAIT FOR 50 NS;

    reset_i_s <= '0';

    WAIT FOR 50 NS;

    mixcolumns_en_i_s <= '1';

    WAIT FOR 150 NS;

    --Round 0:
    -- SubBytes : af 44 d3 ab 16 e6 20 b1 ce 91 01 ae bc 62 06 d5
    -- ShiftRows : af e6 01 d5 16 91 06 ab ce 62 d3 b1 bc 44 20 ae
    -- MixColumns : a0 ae 2f bc 29 8e 6d e0 43 d5 d9 81 21 fa 51 fc
    -- ComputeKey : 75 ec 78 56 5d 42 aa f0 f6 b5 bf 78 ff 7a f0 44
    -- AddRoundKey : d5 42 57 ea 74 cc c7 10 b5 60 66 f9 de 80 a1 b8
    current_key_i_s   <= X"75ec78565d42aaf0f6b5bf78ff7af044";
    mixcolumns_en_i_s <= '1';
    sel_i_s <= '0';

    WAIT;
    END PROCESS;

end aesround_tb_arch; -- aesround_arch

configuration aesround_tb_conf of aesround_tb is
    for aesround_tb_arch
        for DUT : aesround
            use entity LIB_RTL.aesround(aesround_arch);
        end for;
    end for;
end configuration aesround_tb_conf;