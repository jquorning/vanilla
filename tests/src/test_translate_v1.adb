with AUnit.Assertions;

with Vanilla_Substitute;

package body Test_Translate_V1
is
   package DUT renames Vanilla_Substitute;

   function Map (Key : Character) return String is
   begin
      case Key is
         when 'A' => return "Arabica";
         when 'B' => return "Bolivian";
         when 'C' => return "coffee";
         when others => return "";
      end case;
   end Map;

   ---------------
   -- Translate --
   ---------------

   function Translate is
     new DUT.Translate_V1 (Map   => Map,
                           Break => '$');
   ----------------
   -- 01         --
   -- Easy peacy --
   ----------------

   procedure Afprovning_01 (T : in out Fixture)
   is
      Target : constant String :=
        Translate ("Drink $A and $B $C.");
   begin
      AUnit.Assertions.Assert
        (Actual   => Target,
         Expected => "Drink Arabica and Bolivian coffee.",
         Message  => "A01");
   end Afprovning_01;

   ----------------------
   -- 02               --
   -- With unknown key --
   ----------------------

   procedure Afprovning_02 (T : in out Fixture) is
      Target : constant String :=
        Translate ("Drink $A and $B $X.");
   begin
      AUnit.Assertions.Assert
        (Actual   => Target,
         Expected => "Drink Arabica and Bolivian .",
         Message  => "A02");
   end Afprovning_02;

   ------------------------
   -- 03                 --
   -- With unended break --
   ------------------------

   procedure Afprovning_03_Internal is
      Target : constant String :=
        Translate ("Drink $A and $B $C.$");
   begin
      AUnit.Assertions.Assert
        (Actual   => Target,
         Expected => "Drink Arabica and Bolivian coffee.",
         Message  => "A03-1");
   end Afprovning_03_Internal;

   procedure Afprovning_03 (T : in out Fixture) is
   begin
      AUnit.Assertions.Assert_Exception
        (Proc     => Afprovning_03_Internal'Access,
         Message  => "A03-2");
   end Afprovning_03;

end Test_Translate_V1;
