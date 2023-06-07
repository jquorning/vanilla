abstract project $P
is
   Crate_Version := "$V";
   Crate_Name := "$N";

   Alire_Host_OS := "$H";

   Alire_Host_Arch := "$A";

   Alire_Host_Distro := "$D";
   Ada_Compiler_Switches := External_As_List ("ADAFLAGS", " ");
   Ada_Compiler_Switches := Ada_Compiler_Switches &
          (
            "-gnatW8" -- UTF-8 encoding for wide characters
           ,"-Og" -- Optimize for debug
           ,"-ffunction-sections" -- Separate ELF section for each function
           ,"-fdata-sections" -- Separate ELF section for each variable
           ,"-g" -- Generate debug info
           ,"-gnatwa" -- Enable all warnings
           ,"-gnatyu" -- Check unnecessary blank lines
          );

   type Build_Profile_Kind is ("release", "validation", "development");
   Build_Profile : Build_Profile_Kind := "development";

end $P;
