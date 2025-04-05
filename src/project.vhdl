library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tt_um_kryptering is
    port (
        ui_in   : in  unsigned(7 downto 0);
        uo_out  : out unsigned(7 downto 0);
        uio_in  : in  unsigned(7 downto 0);
        uio_out : out unsigned(7 downto 0);
        uio_oe  : out unsigned(7 downto 0);
        ena     : in  std_logic;
        clk     : in  std_logic;
        rst_n   : in  std_logic
    );
end tt_um_kryptering;

architecture Behavioral of tt_um_kryptering is
    signal keys : unsigned(7 downto 0);
    --alias krypt_e : std_logic is keys(7);
    signal krypt_e : std_logic;
    

    signal output : unsigned(7 downto 0);
    signal temp : unsigned(7 downto 0);

    procedure xor_operation (
        a, b : in unsigned(7 downto 0); 
        res : out unsigned(7 downto 0)) is
    begin
        res := a xor b;
    end procedure;

    -- procedure left_shift_operation (
    --     a : in unsigned(7 downto 0);
    --     res : out unsigned(7 downto 0)) is 
    --     begin
    --     res := a(5 downto 0) & a(7 downto 6);
    -- end procedure;

    -- procedure right_shift_operation (
    --     a : in unsigned(7 downto 0);
    --     res : out unsigned(7 downto 0)) is 
    -- begin
    --     res := a(1 downto 0) & a(7 downto 2);
    -- end procedure;


begin
    --uo_out <= unsigned(unsigned(ui_in) + unsigned(uio_in));
    --uo_out <= not (ui_in and uio_in);
    uio_out <= "00000000";
    uio_oe <= "00000000";


    process(clk)
    begin
        if rising_edge(clk) then
            keys <= uio_in;
            temp <= ui_in;
            krypt_e <= keys(7);

            if rst_n = '1' then
                output <= "00000000";
                temp <= "00000000";  
            elsif krypt_e = '1' then
               --temp 00001111
               --keys 11111111
                temp <= (temp xor keys);
               -- temp 11110000
               --keys 11111111
                temp <= temp(6 downto 0) & temp(7);
                --temp 11100001
                --keys 11111111
                keys <= not keys;
                --temp 11100001
                --keys 00000000
               
                temp <= (temp xor keys);
                --temp 11100001
                --keys 00000000

                temp <= temp(5 downto 0) & temp(7 downto 6);
                --temp 10000111
               --keys 00000000

            else
                temp <= temp(0) & temp(7 downto 1);

               
                keys <= not keys;
          
                temp <= (temp xor keys);
                temp <= temp(1 downto 0) & temp(7 downto 2);

               
                keys <= not keys;
  
                temp <= (temp xor keys);
                
            end if;
            output <= temp;   
                
        end if;

    end process;
    uo_out <= output;
    

end Behavioral;


