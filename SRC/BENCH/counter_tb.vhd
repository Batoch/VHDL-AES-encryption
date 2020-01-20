library IEEE;
use IEEE.std_logic_1164.all;
--conversion de bit8 (std_logic_vector) en entier
use IEEE.numeric_std.all;
--pour l'utilisation du type byt8
library LIB_AES;
use LIB_AES.crypt_pack.all;

library LIB_RTL;

entity counter_tb is

end entity counter_tb;

architecture counter_tb_arch of counter_tb is
component counter
    port(
        init_i      : in std_logic;
        clock_i     : in std_logic;
        reset_i     : in std_logic;
        enable_i    : in std_logic;

        counter_o   : out bit4
    );
end component;

signal init_i_s     : std_logic := '1';
signal clock_i_s    : std_logic := '0';
signal reset_i_s    : std_logic;
signal enable_i_s   : std_logic;

signal counter_o_s  : bit4;


begin

DUT : counter port map
    (
        init_i      => init_i_s,
        clock_i     => clock_i_s,
        reset_i     => reset_i_s,
        enable_i    => enable_i_s,
        
        counter_o   => counter_o_s
    );

    clock_i_s   <= not clock_i_s after 20 ns;

    reset_i_s   <= '0' after 0 ns;
    enable_i_s  <= '1' after 0 ns;

    init_i_s    <= '0' after 50 ns;

end counter_tb_arch; -- counter_arch

configuration counter_tb_conf of counter_tb is
    for counter_tb_arch
        for DUT : counter
            use entity LIB_RTL.counter(counter_arch);
        end for;
    end for;
end configuration counter_tb_conf;