with Ada.Text_IO;
with Vanilla_Substitute;

procedure Test_Substitute
is
   Data_Error : exception;

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

   type AString is access String;

   function "-" (Item : String) return AString is
   begin
      return new String'(Item);
   end "-";
   
   Input_01 : constant array (Positive range <>) of AString :=
    (
      -"$$",
      -"Hello Mac $A!",
      -"What is your $S?",
      -"I'm on $a, surely$$!",
      -"$A$S$a",
      -"Check -> $R <-",
      -"Linger $",
      -"S",
      -"Surprise"
    );

   procedure Put_Character (Item : Character)
   is
   begin
      Ada.Text_IO.Put (Item);
   end Put_Character;

   function To_Item_Out (Item : Character) return Character
   is
   begin
      return Item;
   end To_Item_Out;

   package Replacer_01 is new Vanilla_Substitute.Items_V1
     (Item_In     => Character,
      Item_Out    => Character,
      Item_String => String,
      To_Item_Out => To_Item_Out,
      Map         => Mapping,
      Put         => Put_Character);

   package Replacer_02 is new Vanilla_Substitute.Strings_V1
     (Map         => Mapping,
      Put         => Put_Character);
begin

   -----------------
   -- Replacer_01 --
   -----------------

   Replacer_01.Break := '$';

   for Line of Input_01 loop
      Replacer_01.Process (Line.all);
      Ada.Text_IO.New_Line;
   end loop;
      
   Ada.Text_IO.New_Line (2);
   
   -----------------
   -- Replacer_02 --
   -----------------

   for Line of Input_01 loop
      Replacer_02.Process (Line.all);
      Ada.Text_IO.New_Line;
   end loop;
   
   Ada.Text_IO.New_Line (2);
   
end Test_Substitute;
