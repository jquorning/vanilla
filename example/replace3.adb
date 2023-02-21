with Ada.Text_IO;

with Vanilla_Replacer_V1;

procedure Replace3
is
   File_Name_In  : constant string := "config.tpl";
   File_Name_Out : constant string := "config.gpr";

   package TIO renames Ada.Text_IO;

   File_In  : TIO.File_Type;
   File_Out : TIO.File_Type;

   ------------------
   -- Filtered_Put --
   ------------------

   procedure Filtered_Put (Item : Character) is
   begin
      Ada.Text_IO.Put (File_Out, Item);
   end Filtered_Put;

   type String_Access is access String;

--   type Map_Array is array (Character) of String_Access;

   function
      Map (Item : Character)
   return
      String
   is
   begin
      case Item is
         when 'P'    => return "Example";  -- Project
         when 'V'    => return "3.3.3";    -- Version
         when 'N'    => return "example";  -- Name
         when 'A'    => return "x86_64";   -- Arch
         when 'D'    => return "macOS";    -- Distro
         when others => raise Constraint_Error; -- return null;
      end case;
   end Map;

--    function Map (Item : Character) return
--    String_Access is
--    begin
--      case Item is
--       when 'P'    => return new String'("Example");  -- Project
--       when 'V'    => return new String'("3.3.3");    -- Version
--       when 'N'    => return new String'("example");  -- Name
--       when 'A'    => return new String'("x86_64");   -- Arch
--       when 'D'    => return new String'("macOS");    -- Distro
--       when others => return null;
-- end case;
--    end Map;

   -- Map : constant Map_Array := -- array (Character) of String_Access :=
   --   (
   --    'P'    => new String'("Example"),  -- Project
   --    'V'    => new String'("3.3.3"),    -- Version
   --    'N'    => new String'("example"),  -- Name
   --    'A'    => new String'("x86_64"),   -- Arch
   --    'D'    => new String'("macOS"),    -- Distro
   --    others => null
   --   );

   function To_Character_Out (Item : Character) return Character is begin
      return Item;
   end To_Character_Out;

   package GPR_File
     is new Vanilla_Replacer_V1
       (
        Character_In     => Character,
        Character_Out    => Character,
--        String        => String,
--        Map_Array => Map_Array,
	Map       => Map,
	To_Character_Out => To_Character_Out,
--	String_Access => String_Access,
--	New_Line      => ASCII.LF,
	String => String,
	Put           => Filtered_Put);

begin
   TIO.Open (File_In,  TIO.In_File,  File_Name_In );
   TIO.Open (File_Out, TIO.Out_File, File_Name_Out);

--   GPR_File.Map ('P') := new String'("Example");  -- Project
--   GPR_File.Map ('V') := new String'("3.3.3");    -- Version
--   GPR_File.Map ('N') := new String'("example");  -- Name
--   GPR_File.Map ('A') := new String'("x86_64");   -- Arch
--   GPR_File.Map ('D') := new String'("macOS");    -- Distro
--   GPR_File.Break := '$';

--   GPR_File.Process;

   TIO.Close (File_Out);
   TIO.Close (File_In );

end Replace3;
