library IEEE;
use IEEE.std_logic_1164.all;
--conversion de bit8 (std_logic_vector) en entier
use IEEE.numeric_std.all;
--pour l'utilisation du type byt8
library LIB_AES;
use LIB_AES.crypt_pack.all;

entity top is
    port(
        text_i                  : in bit128;
        reset_i                 : in std_logic;
        start_i                 : in std_logic;
        clock_i                 : in std_logic;

        cipher_o                : out bit128;
        aesm_o                  : out std_logic
    );
end entity top;


architecture top_arch of top is

    component aesround is
        port(
            data_i              : in bit128;
            current_key_i       : in bit128;
            clock_i             : in std_logic;
            mixcolumns_en_i     : in std_logic;
            reset_i             : in std_logic;
            sel_i               : in std_logic;

            data_o              : out bit128
        );
    end component aesround;

    component KeyExpansion_I_O_table is
        port (
            key_i             : in  bit128;
            clock_i           : in  std_logic;
            reset_i           : in  std_logic;
            start_i           : in  std_logic;
            round_i           : in  bit4;

            end_o             : out std_logic;
            expansion_key_o   : out bit128
        );
      end component KeyExpansion_I_O_table;

      component counter is
        port(
            init_i              : in std_logic;
            clock_i             : in std_logic;
            reset_i             : in std_logic;
            enable_i            : in std_logic;
    
            counter_o           : out bit4
        );
    end component counter;

    component fsm_moore is
        port(
            clock_i             : in std_logic;
            start_i             : in std_logic;
            compteur_i          : in bit4;
            reset_i             : in std_logic;
            end_key_expander_i  : in std_logic;                  --key expender terminé?
    
            enableRC_o          : out std_logic;
            enableMC_o          : out std_logic;
            enableCompteur_o    : out std_logic;
            enableke_o          : out std_logic;
            initCompteur_o      : out std_logic;
            aesDone_o           : out std_logic;
            enableOutput_o      : out std_logic
            );
    end component fsm_moore;




    signal counter_s            : bit4;
    signal enableCompteur_s     : std_logic;
    signal initCompteur_s       : std_logic;
    signal expansion_key_s      : bit128;
    signal end_key_expander_s   : std_logic;
    signal enableke_s           : std_logic;
    signal current_key_s        : bit128;
    signal sortieaes_s          : bit128;
    signal enableOutput_s       : std_logic;
    signal enableMC_s           : std_logic;
    signal enableRC_s           : std_logic;
    signal stateReg_s           : bit128;


begin


    topcounter : counter port map
        (
            init_i => initCompteur_s,
            clock_i => clock_i,
            reset_i => reset_i,
            enable_i => enableCompteur_s,
    
            counter_o => counter_s
        );
        
    topkeyexpansion : KeyExpansion_I_O_table port map
        (
            key_i => current_key_s,
            clock_i => clock_i,
            reset_i => reset_i,
            start_i => enableke_s,
            round_i => counter_s,

            end_o => end_key_expander_s,
            expansion_key_o => expansion_key_s
        );

    topaesround : aesround port map
        (
            data_i => text_i,
            current_key_i => expansion_key_s,
            clock_i => clock_i,
            mixcolumns_en_i => enableMC_s,
            reset_i => reset_i,
            sel_i => enableRC_s,

            data_o => sortieaes_s
        );

    topfsm : fsm_moore port map
        (
            clock_i => clock_i,
            start_i => start_i,
            compteur_i => counter_s,
            reset_i => reset_i,
            end_key_expander_i => end_key_expander_s,
    
            enableRC_o => enableRC_s,
            enableMC_o => enableMC_s,
            enableCompteur_o => enableCompteur_s,
            enableke_o => enableke_s,
            initCompteur_o => initCompteur_s,
            aesDone_o => aesm_o,
            enableOutput_o => enableOutput_s
            );


    cipher_o <= stateReg_s;


    reg_0 : process (enableOutput_s, reset_i) is       --execute la fonction si clock_i ou reset_i changent
    begin
        if reset_i = '1' then
            stateReg_s <= (others => '0');
        elsif enableOutput_s'event and enableOutput_s = '1' then
            stateReg_s <= sortieaes_s;
        end if;
    end process reg_0;

end top_arch;