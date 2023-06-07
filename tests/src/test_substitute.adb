
--  with Test_Substitutes;
with Suite_01;

with AUnit.Run;
with AUnit.Reporter.Text;

procedure Test_Substitute
is
   procedure Run
     is new AUnit.Run.Test_Runner (Suite_01.Suite);     
--     is new AUnit.Run.Test_Runner (Test_Substitutes.Suite);

   Reporter : AUnit.Reporter.Text.Text_Reporter;
begin
   Run (Reporter);
end Test_Substitute;
