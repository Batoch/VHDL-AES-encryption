library IEEE;
use IEEE.std_logic_1164.all;
--conversion de bit8 (std_logic_vector) en entier
use IEEE.numeric_std.all;
--pour l'utilisation du type byt8
library LIB_AES;
use LIB_AES.crypt_pack.all;


entity fsm_moore is
    port(
        clock_i                 : in std_logic;
        start_i                 : in std_logic;
        compteur_i              : in bit4;
        reset_i                 : in std_logic;
        end_key_expander_i      : in std_logic;                  --key expender terminé?

        enableRC_o              : out std_logic;
        enableMC_o              : out std_logic;
        enableCompteur_o        : out std_logic;
        enableke_o              : out std_logic;
        initCompteur_o          : out std_logic;
        aesDone_o               : out std_logic;
        enableOutput_o          : out std_logic
        );
end entity fsm_moore;

architecture fsm_moore_arch of fsm_moore is

    -- definition du type enumere
    type state is (etat0, etat1, etat2, etat3, etat4, etat5);
    -- Attente, Calcul des sous clés, start, 1er addroundkey
    -- definition des signaux
    signal etat_present, etat_futur : state;

begin -- fsm_moore_arch



seq_0 : process (clock_i, start_i)
begin -- process seq_0
    if start_i = '0' then
        etat_present <= etat0;
    elsif clock_i'event and clock_i = '1' then
        etat_present <= etat_futur;
    end if;
end process seq_0;

comb0 : process (etat_present, start_i, clock_i)
begin -- process comb0
    case etat_present is

        when etat0 =>
            if start_i = '1' then
                etat_futur <= etat1;
            else
                etat_futur <= etat0;
            end if;

        when etat1 =>
            if end_key_expander_i = '1' then
                etat_futur <= etat2;
            else
                etat_futur <= etat1;
            end if;

        when etat2 =>
            etat_futur <= etat3;

        when etat3 =>
            if compteur_i = "1001" then
                etat_futur <= etat4;
            else
                etat_futur <= etat3;
            end if;

        when etat4 =>
            etat_futur <= etat5;

        when etat5 =>
            etat_futur <= etat0;

    end case;
end process comb0;

comb1 : process (etat_present)
begin -- process comb1
    case etat_present is
        when etat0 =>                   --Attente
            enableCompteur_o <= '0';
            initCompteur_o <= '0';
            enableRC_o <= '0';
            enableMC_o <= '0';
            aesDone_o <= '0';
            enableOutput_o <= '0';
            enableke_o <= '0';
        when etat1 =>                   --calcul des clés
            enableCompteur_o <= '1';
            initCompteur_o <= '1';
            enableke_o <= '1';
        when etat2 =>                   --start round 0
            initCompteur_o <= '0';
        when etat3 =>                   --addroundkey
            enableRC_o <= '1';
            enableMC_o <= '1';
        when etat4 =>                   --dernier round
            enableMC_o <= '0';
        when etat5 =>                   --fin
            enableCompteur_o <= '0';
            aesDone_o <= '1';
            enableOutput_o <= '1';

    end case;
end process comb1;



end architecture fsm_moore_arch;