with AUnit.Assertions;

with Ada.Strings.Unbounded;

with Vanilla_Substitute;

package body Test_Substitutes
is
   use AUnit;
   use Ada.Strings.Unbounded;

   Data_Error : exception;

   -------------
   -- Mapping --
   -------------

   function Mapping (Item : Character) return String
   is
   begin
      case Item is
         when '$'    =>  return "$";
         when 'A'    =>  return "Architecture";
         when 'R'    =>  return "Recursive-$S-test";
         when 'S'    =>  return "System";
         when 'a'    =>  return "Ada 2012";
         when others =>  raise Data_Error;
      end case;
   end Mapping;

   Result : Unbounded_String;

   -------------------
   -- Put_Character --
   -------------------

   procedure Put_Character (Item : Character)
   is
   begin
      Append (Result, Item);
   end Put_Character;

   ----------------------
   -- To_Character_Out --
   ----------------------

   function To_Item_Out (Item : Character) return Character is
   begin
      return Item;
   end To_Item_Out;

   ------------------
   -- Item_Replace --
   ------------------

   package Item_Replace
     is new Vanilla_Substitute.Items_V1
       (Item_In     => Character,
        Item_Out    => Character,
        Item_String => String,
        To_Item_Out => To_Item_Out,
        Map         => Mapping,
        Put         => Put_Character);

   generic
      Input  : String;
      Expect : String;
   procedure Item_Test (T : in out Test);

   procedure Item_Test (T : in out Test)
   is
      pragma Unreferenced (T);
      use AUnit.Assertions;
   begin
      Result := Null_Unbounded_String;
      Item_Replace.Process (Input);

      Assert (Result = Expect,
              Message =>
                "'" & Expect & "' expected, "
                & "but got '" & To_String (Result) & "'");
   end Item_Test;

   ------------
   -- Test_1 --
   ------------

   procedure Test_Item_01
     is new Item_Test (Input  => "$$",
                       Expect => "$");
   procedure Test_Item_02
     is new Item_Test (Input  => "Hello Mac $A!",
                       Expect => "Hello Mac Architecture!");
   procedure Test_Item_03
     is new Item_Test (Input  => "What is your $S?",
                       Expect => "What is your System?");
   procedure Test_Item_04
     is new Item_Test (Input  => "I'm on $a, surely$$!",
                       Expect => "I'm on Ada 2012, surely$!");
   procedure Test_Item_05
     is new Item_Test (Input  => "$A$S$a",
                       Expect => "ArchitectureSystemAda 2012");
   procedure Test_Item_06
     is new Item_Test (Input  => "Check -> R <-",
                       Expect => "Check -> R <-");
   procedure Test_Item_07
     is new Item_Test (Input  => "Linger $",
                       Expect => "Linger ");
   procedure Test_Item_08
     is new Item_Test (Input  => "S",
                       Expect => "System");
   procedure Test_Item_09
     is new Item_Test (Input  => "Surprise",
                       Expect => "Surprise");

   procedure Item_01 (T : in out Test) renames Test_Item_01;
   procedure Item_02 (T : in out Test) renames Test_Item_02;
   procedure Item_03 (T : in out Test) renames Test_Item_03;
   procedure Item_04 (T : in out Test) renames Test_Item_04;
   procedure Item_05 (T : in out Test) renames Test_Item_05;
   procedure Item_06 (T : in out Test) renames Test_Item_06;
   procedure Item_07 (T : in out Test) renames Test_Item_07;
   procedure Item_08 (T : in out Test) renames Test_Item_08;
   procedure Item_09 (T : in out Test) renames Test_Item_09;

begin
   Item_Replace.Break := '$';

end Test_Substitutes;
