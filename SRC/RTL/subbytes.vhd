library IEEE;
use IEEE.std_logic_1164.all;
library LIB_AES;
library LIB_RTL;
use LIB_AES.crypt_pack.all;

entity subbytes is
	port(
		data_i : in type_state;
		data_o : out type_state
	);
end entity subbytes;

architecture subbytes_arch of subbytes is
	component sbox
	port(
		data_i : in bit8;
		data_o : out bit8
	);
	end component;

begin
	rows : for i in 0 to 3 generate
		columns : for j in 0 to 3 generate
			label0 : sbox port map (
				data_i => data_i(i)(j),
				data_o => data_o(i)(j));
		end generate columns;
	end generate rows;

end architecture subbytes_arch;

configuration subbytes_conf of subbytes is
	for subbytes_arch
		for rows
			for columns
				for all: sbox
					use entity LIB_RTL.sbox(sbox_arch);
				end for;
			end for;
		end for;
	end for;
end configuration subbytes_conf;