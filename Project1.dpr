program Project1;

uses
  Vcl.Forms,
  mainForm in 'mainForm.pas' {mainView},
  Vcl.Themes,
  Vcl.Styles,
  DB in 'DB.pas' {Base: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Anti-INTRUSO';
  TStyleManager.TrySetStyle('Windows10 Dark');
  Application.CreateForm(TmainView, mainView);
  Application.CreateForm(TBase, Base);
  Application.Run;
end.
