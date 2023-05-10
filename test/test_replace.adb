with Ada.Text_IO;
with Vanilla.Replace;

procedure Test_Replace
is
   Data_Error : exception;

   function Map (Item : Character) return String
   is
   begin
      case Item is
         when '$'    =>  return "$";
         when 'A'    =>  return "Architecture";
         when 'S'    =>  return "System";
         when 'a'    =>  return "Ada 2012";
         when others =>  raise Data_Error;
      end case;
   end Map;

   type AString is access String;

   function "-" (Item : AString) return String
      renames Ada.Strings.Unbounded.To_String;
      
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

   package Output_01 is new Vanilla.Replace.Characters
     (Map => Map,
      Put => Put_Character);
begin
   for Line of Input_01 loop
      Output_01.Process (Line.all);
      Ada.Text_IO.New_Line;
   end for;
end Test_Replace;
