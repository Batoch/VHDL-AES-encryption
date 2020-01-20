library IEEE;
use IEEE.std_logic_1164.all;
--conversion de bit8 (std_logic_vector) en entier
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
--pour l'utilisation du type byt8
library LIB_AES;
use LIB_AES.crypt_pack.all;


entity counter is
    port(
        init_i      : in std_logic;
        clock_i     : in std_logic;
        reset_i     : in std_logic;
        enable_i    : in std_logic;

        counter_o   : out bit4
    );
end entity counter;

architecture counter_arch of counter is

    signal counter_s : bit4;             --represente l etat du compteur

begin -- counter_arch



compteur_0 : process (clock_i, reset_i, enable_i, init_i) is       --execute la fonction si clock_i, reset_i, enable_i ou init_i changent
begin
    if reset_i = '1' then
        counter_s <= (others => '0');
    elsif clock_i'event and clock_i = '1' then
        if enable_i = '1' then
            if init_i = '1' then
                counter_s <= (others => '0');
            else
                counter_s <= counter_s + 1;
                if counter_s > 9 then
                    counter_s <= (others => '0');
                end if;
            end if;
        else
            counter_s <= counter_s;
        end if;
    end if;
end process compteur_0;

counter_o <= counter_s;

end architecture counter_arch;