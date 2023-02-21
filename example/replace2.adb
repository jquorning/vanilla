with Ada.Text_IO;
with Ada.Wide_Wide_Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

with Vanilla_Replacer_V1;

procedure Replace2
is
   --------------
   -- Generate --
   --------------

   procedure Generate (Cmd  : Command;
                       Info : Crate_Init_Info)
   is

      package TIO renames Ada.Wide_Wide_Text_IO;
      use AAA.Strings;

      For_Library : constant Boolean := Info.Kind = Library;
      Name        : constant String := To_String (Info.Name);
      Lower_Name  : constant String := AAA.Strings.To_Lower_Case (Name);
      Upper_Name  : constant String := AAA.Strings.To_Upper_Case (Name);
      Mixed_Name  : constant String := AAA.Strings.To_Mixed_Case (Name);

      Directory     : constant Virtual_File :=
        (if Cmd.In_Place
         then Get_Current_Dir
         else Create (+Name, Normalize => True));
      Src_Directory : constant Virtual_File := Directory / "src";
      Share_Directory : constant Virtual_File :=
         Directory / "share" / Filesystem_String (Lower_Name);

      File : TIO.File_Type;

      function Create (Filename : String) return Boolean;
      --  Return False if the file already exists

      procedure Put_New_Line;
      procedure Put_Line (Item : String);
      procedure Put (Item : String);
      procedure New_Line;
      --  Shortcuts to write to File

      function Q (S : String) return String is ("""" & S & """");
      --  Quote string

      function Q (S : Unbounded_String) return String
      is (Q (To_String (S)));
      --  Quote string

      function Arr (S : String) return String is ("[" & S & "]");
      --  Wrap string into TOML array

      function Q_Arr (Arr : AAA.Strings.Vector) return String
      is (if Arr.Is_Empty
          then "[]"
          else "[""" & Arr.Flatten (""", """) & """]");
      --  String vector to TOML array of strings

      ------------------------------
      -- Generate_Project_File_V1 --
      ------------------------------

      procedure Generate_Project_File_V1
      is
         procedure NL
           renames New_Line;

         package GPR_File
           is new GPR_Generator_V1 (Put      => Put,
                                    New_Line => NL);
         use GPR_File.Shortcuts;

         Filename : constant String :=
            +Full_Name (Directory / (+Lower_Name & ".gpr"));

         Build_Profile : constant String
           := """obj/""" & " & " &
                  Mixed_Name & "_Config.Build_Profile";

         Library_Name : constant String
           := "Project'Library_Name & "".so."" & "
              & Mixed_Name & "_Config.Crate_Version";

         Reloc  : constant String := """relocatable""";
         Static : constant String := """static""";
         PIC    : constant String := """static-pic""";

         Library_Type : constant String
           := "(" & Reloc & ", " & Static & ", " & PIC & ");";

         External_1 : constant String
           := "external (""LIBRARY_TYPE"", ""static"")";

         External_2 : constant String
           := "external (""" & Upper_Name & "_LIBRARY_TYPE"", "
              & External_1 & ");";
      begin
         pragma Style_Checks ("-3");
         --  Suspend eindention checks to let program structure
         --  be like GPR file structue.

         --  Main project file
         if not Create (Filename) then
            Trace.Warning ("Cannot create '" & Filename & "'");
            return;
         end if;

         GPR_File.NL_Before_IS      := False;
         GPR_File.NL_After_FOR_List := False;
         --  GPR File Style

         NL;
         WC ("config/" & Lower_Name & "_config.gpr");                 NL;
         RB (Mixed_Name, GPR_File.Library);                           NL;

         if For_Library then
            FU ("Library_Name   ", QE (Mixed_Name));
            FU ("Library_Version", EX (Library_Name));                NL;
         end if;

         FU ("Create_Missing_Dirs", QE ("True"));                     NL;
         FU ("Source_Dirs", List'(QE ("src/"),
                                  QE ("config/")));
         FU ("Object_Dir ", EX (Build_Profile));

         if For_Library then
            FU ("Library_Dir", QE ("lib"));                           NL;
            FR ("type Library_Type_Type is " & Library_Type);
                                                                      NL;
            FR ("Library_Type : Library_Type_Type :=");
            FR ("  " & External_2);                                   NL;
            FU ("Library_Kind", EX ("Library_Type"));
         else
            FU ("Exec_Dir", QE ("bin"), True);
            FU ("Main    ", LO (Lower_Name & ".adb"));
         end if;
         NL;

         PB ("Compiler");
         FU ("Default_Switches (""Ada"")",
             EX (Mixed_Name & "_Config.Ada_Compiler_Switches"));
         PE ("Compiler");                                             NL;

         PB ("Binder");                                               NL;
            FU ("Switches (""Ada"")",
                LO ("-Es", "Symbolic traceback"),
                Compact => False);                                    NL;
         PE ("Binder");                                               NL;

         PB ("Install");                                              NL;
            FU ("Artifacts (""."")", LO ("share"));                   NL;
         PE ("Install");                                              NL;

         RE (Mixed_Name);

         pragma Style_Checks ("3");

         TIO.Close (File);
      end Generate_Project_File_V1;

      ------------------------------
      -- Generate_Project_File_V2 --
      ------------------------------

      procedure Generate_Project_File_V2
      is

         procedure Filtered_Put (Item : Character) is
         begin
            Ada.Text_IO.Put (Item);
         end Filtered_Put;

         type String_Access
           is access String;

         package GPR_File
           is new Vanilla_Replacer_V1
                    (Character     => Standard.Character,
                     String        => Standard.String,
                     String_Access => String_Access,
                     New_Line      => ASCII.LF,
                     Put           => Filtered_Put);
		  -- is new GPR_Generator_V2
                  --   (Character     => Standard.Character,
                  --    String        => Standard.String,
                  --    String_Access => String_Access,
                  --    New_Line      => ASCII.LF,
                  --    Put           => Filtered_Put);

         Filename : constant String :=
            +Full_Name (Directory / (+Lower_Name & ".gpr"));

         Build_Profile : constant String
           := """obj/""" & " & " &
                  Mixed_Name & "_Config.Build_Profile";

         Library_Name : constant String
           := "Project'Library_Name & "".so."" & "
              & Mixed_Name & "_Config.Crate_Version";

--         Reloc  : constant String := """relocatable""";
--         Static : constant String := """static""";
--         PIC    : constant String := """static-pic""";

--         Library_Type : constant String
--           := "(" & Reloc & ", " & Static & ", " & PIC & ");";

         External_1 : constant String
           := "external (""LIBRARY_TYPE"", ""static"")";

         External_2 : constant String
           := "external (""" & Upper_Name & "_LIBRARY_TYPE"", "
              & External_1 & ");";
--         procedure Emit_Lib_GPR;
--         procedure Emit_Bin_GPR;
--         procedure Emit_Lib_GPR is separate;
--         procedure Emit_Bin_GPR is separate;

         NL : constant Character := ASCII.LF;
         procedure P (Item : String) renames GPR_File.Put;
      begin
         --  Main project file
         if not Create (Filename) then
            Trace.Warning ("Cannot create '" & Filename & "'");
            return;
         end if;

         GPR_File.Map ('N') := new String'(Lower_Name);
--         GPR_File.Map ('L', GPR_File.Library);
         GPR_File.Map ('M') := new String'(Mixed_Name);
         GPR_File.Map ('l') := new String'(Library_Name);
         GPR_File.Map ('r') := new String'("""relocatable""");
         GPR_File.Map ('s') := new String'("""static""");
         GPR_File.Map ('P') := new String'("""PIC""");
         GPR_File.Break := '$';

         pragma Style_Checks ("-3");
	 P ("");
	 P ("with ""config/$N_config.gpr""");
	 P ("");
	 P ("project $L");
	 P ("is");
P ("   for Library_Name    use ""$M""");
P ("   for Library_Version use ""$l""");
P ("");
P ("   for Create_Missing_dirs use ""True""");
P ("   for Source_Dirs, (""src/"",");
P ("                     ""config/"");");
P ("   for Object_Dir use");
P ("end $L;");
  	 pragma Style_Checks ("3");
         --  NL;
         --  WC ("config/" & Lower_Name & "_config.gpr");                 NL;
         --  RB (Mixed_Name, GPR_File.Library);                           NL;

         --  if For_Library then
         --    FU ("Library_Name   ", QE (Mixed_Name));
         --    FU ("Library_Version", EX (Library_Name));                NL;
         --  end if;

         --  FU ("Create_Missing_Dirs", QE ("True"));                     NL;
         --  FU ("Source_Dirs", List'(QE ("src/"),
         --                          QE ("config/")));
         --  FU ("Object_Dir ", EX (Build_Profile));

         --  if For_Library then
         --    FU ("Library_Dir", QE ("lib"));                           NL;
         --    FR ("type Library_Type_Type is " & Library_Type);
         --                                                              NL;
         --    FR ("Library_Type : Library_Type_Type :=");
         --    FR ("  " & External_2);                                   NL;
         --    FU ("Library_Kind", EX ("Library_Type"));
         --  else
         --    FU ("Exec_Dir", QE ("bin"), True);
         --    FU ("Main    ", LO (Lower_Name & ".adb"));
         --  end if;
         --  NL;

         --  PB ("Compiler");
         --  FU ("Default_Switches (""Ada"")",
         --     EX (Mixed_Name & "_Config.Ada_Compiler_Switches"));
         --  PE ("Compiler");                                             NL;

         --  PB ("Binder");                                               NL;
         --    FU ("Switches (""Ada"")",
         --        LO ("-Es", "Symbolic traceback"),
         --        Compact => False);                                    NL;
         --  PE ("Binder");                                               NL;

         --  PB ("Install");                                              NL;
         --    FU ("Artifacts (""."")", LO ("share"));                   NL;
         --  PE ("Install");                                              NL;

         --  RE (Mixed_Name);

         --  pragma Style_Checks ("3");

         TIO.Close (File);
      end Generate_Project_File_V2;

      ------------
      -- Create --
      ------------

      function Create (Filename : String) return Boolean is
      begin
         if Ada.Directories.Exists (Filename) then
            Trace.Warning (Filename & " already exists.");
            return False;
         end if;

         TIO.Create (File, TIO.Out_File, Filename);

         return True;
      end Create;

      ------------------
      -- Put_New_Line --
      ------------------

      procedure Put_New_Line is
      begin
         TIO.New_Line (File);
      end Put_New_Line;

      --------------
      -- Put_Line --
      --------------

      procedure Put_Line (Item : String) is
      begin
         TIO.Put_Line (File, WW (Item));
      end Put_Line;

      ---------
      -- Put --
      ---------

      procedure Put (Item : String)
      is
      begin
         TIO.Put (File, WW (Item));
      end Put;

      --------------
      -- New_Line --
      --------------

      procedure New_Line is
      begin
         TIO.New_Line (File);
      end New_Line;

   begin
      --  Crate dir
      Directory.Make_Dir;

      if not Cmd.No_Skel then
         Generate_Project_File;
         Src_Directory.Make_Dir;
         Share_Directory.Make_Dir;
         if For_Library then
            Generate_Root_Package;
         else
            Generate_Program_Main;
         end if;
         Generate_Gitignore;
      end if;
   end Generate;

end Replace2;
