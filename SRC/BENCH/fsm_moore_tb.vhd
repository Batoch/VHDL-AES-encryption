library IEEE;
use IEEE.std_logic_1164.all;
--conversion de bit8 (std_logic_vector) en entier
use IEEE.numeric_std.all;
--pour l'utilisation du type byt8
library LIB_AES;
use LIB_AES.crypt_pack.all;

library LIB_RTL;

entity fsm_moore_tb is
end entity fsm_moore_tb;

architecture fsm_moore_tb_arch of fsm_moore_tb is
component fsm_moore
port(
    clock_i                     : in std_logic;
    start_i                     : in std_logic;
    compteur_i                  : in bit4;
    reset_i                     : in std_logic;
    end_key_expander_i          : in std_logic;

    enableRC_o                  : out std_logic;
    enableMC_o                  : out std_logic;
    enableCompteur_o            : out std_logic;
    enableke_o                  : out std_logic;
    initCompteur_o              : out std_logic;
    aesDone_o                   : out std_logic;
    enableOutput_o              : out std_logic
    );
end component;

signal compteur_i_s             : bit4;
signal reset_i_s                : std_logic := '1';
signal start_i_s                : std_logic := '0';
signal clock_i_s                : std_logic := '0';
signal end_key_expander_i_s     : std_logic := '0';


signal enableRC_o_s             : std_logic;
signal enableMC_o_s             : std_logic;
signal enableCompteur_o_s       : std_logic;
signal enableke_o_s             : std_logic;
signal initCompteur_o_s         : std_logic;
signal aesDone_o_s              : std_logic;
signal enableOutput_o_s         : std_logic;


begin

DUT : fsm_moore port map
    (
        compteur_i          => compteur_i_s,
        reset_i             => reset_i_s,
        start_i             => start_i_s,
        clock_i             => clock_i_s,
        end_key_expander_i  => end_key_expander_i_s,

        enableRC_o          => enableRC_o_s,
        enableMC_o          => enableMC_o_s,
        enableCompteur_o    => enableCompteur_o_s,
        enableke_o          => enableke_o_s,
        initCompteur_o      => initCompteur_o_s,
        aesDone_o           => aesDone_o_s,
        enableOutput_o      => enableOutput_o_s
    );

    clock_i_s <= not clock_i_s after 20 ns;


    PROCESS BEGIN


    WAIT FOR 50 NS;
    reset_i_s <= '0';

    WAIT FOR 50 NS;

    start_i_s <= '1';

    WAIT FOR 150 NS;

    end_key_expander_i_s <= '1';

    WAIT FOR 90 NS;                 --attente du passage a l'etat 3
    compteur_i_s <= "0000";
    WAIT FOR 25 NS;
    compteur_i_s <= "0001";
    WAIT FOR 25 NS;
    compteur_i_s <= "1001";         --inutile de compter jusqu'a 9 de 1 en 1, car tous les round de 1 a 9 sont effectués dans le meme etat


    WAIT;
    END PROCESS;

end fsm_moore_tb_arch; -- fsm_moore_arch

configuration fsm_moore_tb_conf of fsm_moore_tb is
    for fsm_moore_tb_arch
        for DUT : fsm_moore
            use entity LIB_RTL.fsm_moore(fsm_moore_arch);
        end for;
    end for;
end configuration fsm_moore_tb_conf;