program Nevod;

uses
  Forms,
  main in 'main.pas' {FMain},
  Shared in '..\Shared\Shared.pas',
  Base64 in '..\Crypt\Base64.pas',
  Blowfish in '..\Crypt\Blowfish.pas',
  DCPcrypt in '..\Crypt\DCPcrypt.pas',
  Exceptions in '..\Shared\Exceptions.pas',
  SHA1 in '..\Crypt\SHA1.pas',
  RegExpr in '..\Libs\RegExpr.pas',
  PerlRegEx in '..\Libs\RegExp\PerlRegEx.pas',
  FilterManager in '..\Shared\FilterManager.pas',
  CustomEditor in 'CustomEditor.pas' {FCustomEditor};
 // AddAccount in 'AddAccount.pas' {FAddAccount};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFMain, FMain);
  //Application.CreateForm(TFAddAccount, FAddAccount);
  //  Application.CreateForm(TFCustomEditor, FCustomEditor);  // форма редактора фильтров
  Application.Run;
end.
