with Test_Substitutes;
with Test_Translate_V1;
with Test_Translate_V2;

with AUnit.Test_Caller;

package body Suite_01
is
   use AUnit.Test_Suites;
   package Trv1 renames Test_Translate_V1;
   package Trv2 renames Test_Translate_V2;

   package Caller  is new AUnit.Test_Caller (Test_Substitutes.Test);
   package Caller1 is new AUnit.Test_Caller (Trv1.Fixture);
   package Caller2 is new AUnit.Test_Caller (Trv2.Fixture);

   function Suite return Access_Test_Suite
   is
      use Test_Substitutes;

      Ret : constant Access_Test_Suite := new Test_Suite;
   begin
      Ret.Add_Test (Caller.Create ("Item 01", Item_01'Access));
      Ret.Add_Test (Caller.Create ("Item 02", Item_02'Access));
      Ret.Add_Test (Caller.Create ("Item 03", Item_03'Access));
      Ret.Add_Test (Caller.Create ("Item 04", Item_04'Access));
      Ret.Add_Test (Caller.Create ("Item 05", Item_05'Access));
      Ret.Add_Test (Caller.Create ("Item 06", Item_06'Access));
      Ret.Add_Test (Caller.Create ("Item 07", Item_07'Access));
      Ret.Add_Test (Caller.Create ("Item 08", Item_08'Access));
      Ret.Add_Test (Caller.Create ("Item 09", Item_09'Access));

      Ret.Add_Test (Caller1.Create ("Tr_V1 01", Trv1.Afprovning_01'Access));
      Ret.Add_Test (Caller1.Create ("Tr_V1 02", Trv1.Afprovning_02'Access));
      Ret.Add_Test (Caller1.Create ("Tr_V1 03", Trv1.Afprovning_03'Access));

      Ret.Add_Test (Caller2.Create ("Tr_V2 01", Trv2.Afprovning_01'Access));
      Ret.Add_Test (Caller2.Create ("Tr_V2 02", Trv2.Afprovning_02'Access));
      Ret.Add_Test (Caller2.Create ("Tr_V2 03", Trv2.Afprovning_03'Access));

      return Ret;
   end Suite;

end Suite_01;
