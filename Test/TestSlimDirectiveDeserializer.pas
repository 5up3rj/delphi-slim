unit TestSlimDirectiveDeserializer;

interface

uses TestFramework, SlimDirectiveDeserializer, SlimDirective;

type TestTSlimDirectiveDeserializer = class(TTestCase)
  published
    procedure TestSimpleString;
    procedure TestDirectiveWithListOfOneString;
    procedure TestDirectiveWithTwoStrings;
    procedure TestListInList;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  private
    Deserializer : TSlimDirectiveDeserializer;
end;

implementation

{ TestTSlimDirectiveDeserializer }

procedure TestTSlimDirectiveDeserializer.SetUp;
begin
  Deserializer := TSlimDirectiveDeserializer.Create;
end;

procedure TestTSlimDirectiveDeserializer.TearDown;
begin
  Deserializer.Free;
end;


procedure TestTSlimDirectiveDeserializer.TestSimpleString;
var
  directive : TSlimDirective;
begin
  directive := Deserializer.Deserialize('000005:hello');

  CheckEquals(1, directive.Length);
//  CheckIs(directive, TSlimStringDirective);
  CheckEquals('hello', directive.Value);
end;



procedure TestTSlimDirectiveDeserializer.TestDirectiveWithListOfOneString;
var
  directive : TSlimDirective;
begin
  directive := Deserializer.Deserialize('000022:[000001:000007:bonjour:]');

  CheckEquals(1, directive.Length);
  CheckEquals('bonjour',directive.GetItem(0).Value);
end;

procedure TestTSlimDirectiveDeserializer.TestDirectiveWithTwoStrings;
var
  directive : TSlimDirective;
begin
  directive := Deserializer.Deserialize('000037:[000002:000005:Hello:000007:world !:]');

  CheckEquals(2, directive.Length);
  CheckEquals('Hello',directive.GetItem(0).Value);
  CheckEquals('world !',directive.GetItem(1).Value);
end;

procedure TestTSlimDirectiveDeserializer.TestListInList;
var
  directive : TSlimDirective;
  sublist : TSlimDirective;
begin
  directive := Deserializer.Deserialize('000068:[000002:000005:Hello:000041:[000002:000009:wonderful:000007:world !:]:]');

  CheckEquals(2, directive.Length);
  CheckEquals('Hello',directive.GetItem(0).Value);
  sublist := directive.GetItem(1);
  CheckEquals(2, sublist.Length);
  CheckEquals('wonderful',sublist.GetItem(0).Value);
  CheckEquals('world !',sublist.GetItem(1).Value);
end;

initialization
  RegisterTest(TestTSlimDirectiveDeserializer.Suite);
end.
