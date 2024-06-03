unit mainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Imaging.pngimage, Vcl.Mask, Vcl.Buttons, Vcl.ComCtrls, TLHelp32,
  Vcl.DBCtrls, System.ImageList, Vcl.ImgList ;

type
  TmainView = class(TForm)
    imgBackground: TImage;
    LoginPanel: TPanel;
    Tiempo: TTimer;
    lblCartel1: TLabel;
    Image1: TImage;
    Shape1: TShape;
    inputPass: TLabeledEdit;
    imgState: TImage;
    lblStatus: TLabel;
    btnAceptar: TBitBtn;
    btnOptions: TBitBtn;
    Label3: TLabel;
    lblCartel2: TLabel;
    PageControl: TPageControl;
    Login: TTabSheet;
    Options: TTabSheet;
    optionsPanel: TPanel;
    Shape2: TShape;
    Label1: TLabel;
    Image3: TImage;
    lblNota: TLabel;
    oldPass: TEdit;
    newPass: TEdit;
    confirmPass: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Image4: TImage;
    btnCambiar: TBitBtn;
    btnCancelar: TBitBtn;
    btnAuto: TBitBtn;
    editPass: TDBEdit;
    Carteles: TTabSheet;
    cartelPanel: TPanel;
    Shape3: TShape;
    Label9: TLabel;
    Image5: TImage;
    btnAceptarCartel: TBitBtn;
    lblTexto: TLabel;
    imgNoti: TImage;
    ImageList: TImageList;
    tiempoStatus: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TiempoTimer(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnOptionsClick(Sender: TObject);
    procedure btnCambiarClick(Sender: TObject);
    procedure btnAceptarCartelClick(Sender: TObject);
    procedure btnAceptarClick(Sender: TObject);

    procedure evaluarState;
    procedure AbrirConexion;
    procedure CambiarCartel(Icono: Integer ; Page: Integer; Mensaje: String);
    procedure btnAutoClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure tiempoStatusTimer(Sender: TObject);

  private
    procedure Aereo(var m: TWMWINDOWPOSCHANGED); MESSAGE WM_WindowPosChanging;
  public
  end;

  // My functions & Methods
//  function KillTask(FileName:String):integer;

var
  mainView: TmainView;
  clave:string;
  back: integer;

implementation

uses methods, DB;
{$R *.dfm}


procedure TmainView.Aereo(var m: TWMWindowPosMsg);
begin
  m.WindowPos.hwndInsertAfter := HWND_TOP;
end;

procedure TmainView.btnAceptarCartelClick(Sender: TObject);
begin
    Case back of
      0: PageControl.ActivePageIndex := 0;
      1: PageControl.ActivePageIndex := 1;
    End;
end;

procedure TmainView.btnAceptarClick(Sender: TObject);
Var
  I:Integer;
begin
    if inputPass.Text = clave then
        Begin
            AlphaBlend := True;
            UpdateWindow(Handle);

            for I := 50 downto 10 do
              Begin
                 AlphaBlendValue :=  5 * I;
                 Sleep(20);
              End;

            Application.Terminate
        End
    else CambiarCartel(2, 2,'CONTRASEÑA INCORRECTA.');
end;

procedure TmainView.btnAutoClick(Sender: TObject);
begin
  if (oldpass.Text = clave) then
      Begin
         Base.DAO.Edit;
         editPass.Text := 'default';
         Base.Query.Post;
         CambiarCartel(3, 2,'REGISTRO BORRADO.');
         back := 0;
         evaluarState;
      End
  else CambiarCartel(2, 2,'CONTRASEÑA INCORRECTA.');

end;

procedure TmainView.btnCambiarClick(Sender: TObject);
begin
  back := 1;

  if (oldpass.Text = clave) then
    Begin
        if (newpass.Text = confirmPass.text) then
            Begin
               Base.DAO.Edit;
               editPass.Text := confirmPass.text;
               Base.Query.Post;
               oldpass.Clear;
               newpass.Clear;
               confirmPass.Clear;
               CambiarCartel(3, 2,'HA CAMBIADO LA CLAVE.');
               back := 0;
               evaluarState;
            End
        else
          Begin
             newpass.Clear;
             confirmPass.Clear;
             CambiarCartel(4, 2,'SE HA EQUIVOCADO.');
          End;
    End
   else CambiarCartel(2, 2,'CLAVE INCORRECTA.');
end;

procedure TmainView.btnCancelarClick(Sender: TObject);
begin
  PageControl.ActivePageIndex := 0;
end;

procedure TmainView.btnOptionsClick(Sender: TObject);
begin
  PageControl.ActivePageIndex := 1;
end;

procedure TmainView.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose  := False;
end;

procedure TmainView.FormCreate(Sender: TObject);
begin
  mainView.Width := Screen.Width;
  mainView.Height := Screen.Height;
  back  := 0;
end;

procedure TmainView.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ((Key = VK_LWIN) or (Key = VK_RWIN)) then Abort;
end;

procedure TmainView.FormShow(Sender: TObject);
Var
  pantalla  :hdc;
begin

  imgBackground.SetBounds(0,0, Screen.width, Screen.Height);

  pantalla  := GetDesktopWindow;
  BitBlt(imgBackground.Canvas.Handle, 0, 0, Screen.width, Screen.Height ,
          getDC(pantalla), 0, 0, srcCopy);

  ReleaseDC(0, pantalla);
  imgbackground.autosize := True;

  PageControl.Top := ((mainView.Height - PageControl.Top) div 2) - 80;
  PageControl.Left := ((mainView.Width - PageControl.Left) div 2) - 80;

  AbrirConexion;
  evaluarState;
end;

procedure TmainView.tiempoStatusTimer(Sender: TObject);
begin
      if lblStatus.Font.Color = clBlack then
          lblStatus.Font.Color := clred
      else lblStatus.Font.Color := clBlack;
end;

procedure TmainView.TiempoTimer(Sender: TObject);
begin
      if lblCartel1.Font.Color = clWhite then
          lblCartel1.Font.Color := clred
      else lblCartel1.Font.Color := clWhite;

      if lblCartel2.Font.Color = clWhite then
          lblCartel2.Font.Color := clred
      else lblCartel2.Font.Color := clWhite;
end;

procedure TmainView.AbrirConexion;
Begin

  Try
   Base.Conexion.Params.Values['Database'] := ExtractFilePath(Application.ExeName) + '\Security.dll';
   Base.Conexion.Params.Values['Password'] := 'aE7$cY6-';
   Base.Conexion.Open;
   Base.Query.Open;

  Except
     Application.MessageBox('Falta "Security.dll", restaurelo.',
     'ERROR', MB_OK + MB_ICONERROR);
      Application.Terminate;
  end;

End;

procedure TmainView.evaluarState;
Begin

clave := Base.Query.FieldByName('password').AsString;

  if (clave = 'default') then
    Begin
     ImageList.GetIcon(0, imgState.Picture.Icon);
     lblNota.visible := True;
     lblStatus.Caption := 'Introduzca su contraseña de doble factor.';
     tiempoStatus.Enabled := False;
     lblStatus.FOnt.Color := clBlack;
    End
  else
    Begin
      ImageList.GetIcon(1, imgState.Picture.Icon);
      lblNota.visible := false;
      lblStatus.Caption := 'P C  B L O Q U E A D O.';
      tiempoStatus.Enabled := True;
    End;

End;

procedure TmainView.CambiarCartel(Icono: Integer; Page: Integer; Mensaje: String);
Begin
     ImageList.GetIcon(Icono, imgNoti.Picture.Icon);
     PageControl.ActivePageIndex := Page;
     lblTexto.Caption := Mensaje;
End;


end.
