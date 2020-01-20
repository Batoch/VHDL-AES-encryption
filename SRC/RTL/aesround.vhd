library IEEE;
use IEEE.std_logic_1164.all;
--conversion de bit8 (std_logic_vector) en entier
use IEEE.numeric_std.all;
--pour l'utilisation du type byt8
library LIB_AES;
use LIB_AES.crypt_pack.all;

entity aesround is
    port(
        data_i                  : in bit128;
        current_key_i           : in bit128;
        clock_i                 : in std_logic;
        mixcolumns_en_i         : in std_logic;
        reset_i                 : in std_logic;
        sel_i                   : in std_logic;

        data_o                  : out bit128
    );
end entity aesround;


architecture aesround_arch of aesround is

component addroundkey
    port(
        data_i                  : in type_state;
        key_i                   : in type_state;
        data_o                  : out type_state
    );
end component;

component subbytes
    port(
        data_i                  : in type_state;
        data_o                  : out type_state
    );
end component;

component shiftrow
    port(
        data_i                  : in type_state;
        data_o                  : out type_state
    );
end component;

component mixcolumns
    port(
        data_i                  : in type_state;
        mix_i                   : in std_logic;
        data_o                  : out type_state
    );
end component;


--signaux externes
signal current_key_typestate_s  : type_state;
-- signaux interne
signal subbyte_s                : type_state;
signal shiftrow_s               : type_state;
signal mixcolumns_s             : type_state;
signal addroundkey_s            : type_state;
signal mux1_s                   : type_state;
signal stateReg_s               : type_state;


begin


    compsubbytes : subbytes port map                    --entre mux d'entrée et shiftrow
        (
            data_i => stateReg_s,
            data_o => subbyte_s
        );
    compshiftrow : shiftrow port map                    --entre subbytes et mixcolumns
        (
            data_i => subbyte_s,
            data_o => shiftrow_s
        );
    compmixcolumns : mixcolumns port map                --entre shiftrow et mux
        (
            data_i => shiftrow_s,
            mix_i => mixcolumns_en_i,
            data_o => mixcolumns_s
        );


    --mux:                                              --entre mixcolumns et addroundkey
    mux1_s <= bit128totypestate(data_i) when sel_i = '0' else mixcolumns_s;
   
    current_key_typestate_s <= bit128totypestate(current_key_i);

    compaddroundkey : addroundkey port map              --entre mux et reg0
        (
            data_i => mux1_s,
            key_i => bit128totypestate(current_key_i),
            data_o => addroundkey_s
        );


    data_o <= typestatetobit128(stateReg_s);


    reg_0 : process (clock_i, reset_i) is               --execute la fonction si clock_i ou reset_i changent
    begin
        if reset_i = '1' then
            lig : for i in 0 to 3 loop
                col : for j in 0 to 3 loop
                    stateReg_s(i)(j) <= (others => '0');
                end loop;
            end loop;
        elsif clock_i'event and clock_i = '1' then
            stateReg_s <= addroundkey_s;
        end if;
    end process reg_0;

end aesround_arch;