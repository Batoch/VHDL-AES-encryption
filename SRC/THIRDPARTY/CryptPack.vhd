--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 


library IEEE;
use IEEE.STD_LOGIC_1164.all;

package crypt_pack is

  
  subtype bit4 is std_logic_vector(3 downto 0);
  subtype bit8 is std_logic_vector(7 downto 0);
  subtype bit16 is std_logic_vector(15 downto 0);
  subtype bit32 is std_logic_vector(31 downto 0);
  subtype bit128 is std_logic_vector(127 downto 0);

  type row_state is array(0 to 3) of bit8;
  type column_state is array(0 to 3) of bit8;
  type type_state is array(0 to 3) of row_state;
  type type_shift is array(0 to 3) of integer range 0 to 3;
  type type_temp is array(0 to 3) of bit8;
  type row_key is array(0 to 3) of bit8;
  type type_key is array(0 to 3) of row_key;
  type reg_w is array(0 to 3) of bit32;
  type type_rcon is array(0 to 10) of bit8;

  FUNCTION fois2(data_i : IN bit8) RETURN bit8;

  FUNCTION fois3(data_i : IN bit8) RETURN bit8;

  FUNCTION bit128totypestate(data_i : IN bit128) RETURN type_state;

  FUNCTION typestatetobit128(data_i : IN type_state) RETURN bit128;

-- Constant rcon
  constant Rcon : type_rcon := (
    X"01", X"02", X"04", X"08", X"10", X"20", X"40", X"80", X"1b", X"36", X"00"
    );
	
  function "xor" ( L,R: column_state ) return column_state; 

end crypt_pack;


package body crypt_pack is

	function "xor" ( L,R: column_state ) return column_state is
	variable RESULT: column_state;
	begin
	  for i in 0 to 3 loop
			RESULT(i) := L(i) xor R(i);
		end loop;
      return RESULT;
	end "xor";


  FUNCTION fois2(data_i : bit8)
  RETURN bit8 IS
    variable temp : std_logic_vector(8 downto 0);
  BEGIN
      temp := (data_i & '0');
      temp(7 downto 0) := temp(7 downto 0) XOR ("000" & data_i(7) & data_i(7) & '0' & data_i(7) & data_i(7));
      return temp(7 downto 0);
  END fois2;

  FUNCTION fois3(data_i : IN bit8)
  RETURN bit8 IS
    variable temp : bit8;
  BEGIN
      temp := fois2(data_i) XOR data_i;
      return temp;
  END fois3;

  FUNCTION bit128totypestate(data_i : IN bit128)
  RETURN type_state IS
    variable temp : type_state;
  BEGIN
    K1 : for col in 0 to 3 loop
      K2 : for lin in 0 to 3 loop
        temp(lin)(col) := data_i(127-32*col-8*lin downto 120-32*col-8*lin);
      end loop;
    end loop;
    return temp;
  END bit128totypestate;

  FUNCTION typestatetobit128(data_i : IN type_state)
  RETURN bit128 IS
    variable temp : bit128;
  BEGIN
    K1 : for lin in 0 to 3 loop
      K2 : for col in 0 to 3 loop
        temp(127-32*col-8*lin downto 120-32*col-8*lin) := data_i(lin)(col);
      end loop;
    end loop;
    return temp;
  END typestatetobit128;

end package body crypt_pack;