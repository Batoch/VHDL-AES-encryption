library IEEE;
use IEEE.std_logic_1164.all;
--conversion de bit8 (std_logic_vector) en entier
use IEEE.numeric_std.all;
--pour l'utilisation du type byt8
library LIB_AES;
use LIB_AES.crypt_pack.all;

library LIB_RTL;

entity top_tb is
end entity top_tb;

architecture top_tb_arch of top_tb is
component top
    port(
        text_i                  : in bit128;
        reset_i                 : in std_logic;
        start_i                 : in std_logic;
        clock_i                 : in std_logic;

        cipher_o                : out bit128;
        aesm_o                  : out std_logic
    );
end component;

signal text_i_s                 : bit128;
signal reset_i_s                : std_logic := '1';
signal start_i_s                : std_logic := '0';
signal clock_i_s                : std_logic := '0';

signal cipher_o_s               : bit128;
signal aesm_o_s                 : std_logic;


begin

DUT : top port map
    (
        text_i      => text_i_s,
        reset_i     => reset_i_s,
        start_i     => start_i_s,
        clock_i     => clock_i_s,

        cipher_o    => cipher_o_s,
        aesm_o      => aesm_o_s
    );

    clock_i_s <= not clock_i_s after 20 ns;

    PROCESS BEGIN


    --Init:
    -- SetPlaintext : 52 65 73 74 6f 20 65 6e 20 76 69 6c 6c 65 20 3f
    text_i_s <= X"526573746f20656e2076696c6c65203f";

    WAIT FOR 50 NS;

    reset_i_s <= '0';

    WAIT FOR 50 NS;

    start_i_s <= '1';



    WAIT;
    END PROCESS;

end top_tb_arch; -- top_arch

configuration top_tb_conf of top_tb is
    for top_tb_arch
        for DUT : top
            use entity LIB_RTL.top(top_arch);
        end for;
    end for;
end configuration top_tb_conf;