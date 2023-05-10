with Ada.Text_IO;
with Vanilla_Replace;

procedure Test_Replace
is
   Data_Error : exception;

   function Mapping (Item : Character) return String
   is
   begin
      case Item is
         when '$'    =>  return "$";
         when 'A'    =>  return "Architecture";
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
      -"Hello Mac $A !",
      -"What is your $S",
      -"I'm on $a, surely$$!"
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

   package Output_01 is new Vanilla_Replace.Items_V1
     (Item_In     => Character,
      Item_Out    => Character,
      Item_String => String,
      To_Item_Out => To_Item_Out,
      Map         => Mapping,
      Put         => Put_Character);
begin
   for Line of Input_01 loop
      Output_01.Process (Line.all);
      Ada.Text_IO.New_Line;
   end loop;
end Test_Replace;
