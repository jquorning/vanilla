with AUnit.Test_Fixtures;

package Test_Translate_V2
is
   type Fixture
     is new AUnit.Test_Fixtures.Test_Fixture
     with null record;

   procedure Afprovning_01 (T : in out Fixture);
   procedure Afprovning_02 (T : in out Fixture);
   procedure Afprovning_03 (T : in out Fixture);

end Test_Translate_V2;
