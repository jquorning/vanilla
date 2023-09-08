with Ada.Text_IO;

with Vanilla_Substitute;

procedure Substitute
is
   File_Name_In  : constant String := "source.txt";
   File_Name_Out : constant String := "target.txt";

   package TIO renames Ada.Text_IO;

   File_In  : TIO.File_Type;
   File_Out : TIO.File_Type;

   Data_Error : exception;

   ---------
   -- Put --
   ---------

   procedure Put (Item : Character) is
   begin
      TIO.Put (File_Out, Item);
   end Put;

   ---------
   -- Map --
   ---------

   function Map (Item : Character) return String
   is
   begin
      case Item is
         when 'H'    => return "My_Host_Name";
         when 'P'    => return "Example";  -- Project
         when 'V'    => return "3.3.3";    -- Version
         when 'N'    => return "example";  -- Name
         when 'A'    => return "x86_64";   -- Arch
         when 'D'    => return "macOS";    -- Distro
         when others =>
            TIO.Put_Line ("Unexpected Item: " & Item);
            raise Data_Error;
      end case;
   end Map;

   --------------
   -- GPR_File --
   --------------

   package GPR_File
     is new Vanilla_Substitute.Strings_V1
       (Map => Map,
        Put => Put);

   ------------------------
   -- Process_Source_Txt --
   ------------------------

   procedure Process_Source_Txt
   is
      use TIO;
   begin
      Open (File_In,  TIO.In_File,  File_Name_In);
      begin
         Create (File_Out, TIO.Out_File, File_Name_Out);
      exception when others =>
         Open (File_Out, TIO.Out_File, File_Name_Out);
      end;

      while not End_Of_File (File_In) loop
         declare
            Line : constant String := Get_Line (File_In);
         begin
            GPR_File.Process (Line);
            New_Line (File_Out);
         end;
      end loop;

      Close (File_Out);
      Close (File_In);
   end Process_Source_Txt;

begin
   Process_Source_Txt;
end Substitute;
