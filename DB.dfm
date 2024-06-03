object Base: TBase
  Height = 91
  Width = 261
  object Conexion: TFDConnection
    Params.Strings = (
      
        'Database=D:\Proyectos RAD Studio\Anti-Intruso\Win32\Debug\Securi' +
        'ty.dll'
      'DriverID=SQLite')
    LoginPrompt = False
    Left = 32
    Top = 16
  end
  object Query: TFDQuery
    Connection = Conexion
    SQL.Strings = (
      'SELECT * FROM usuario')
    Left = 200
    Top = 16
  end
  object DAO: TDataSource
    DataSet = Query
    Left = 120
    Top = 16
  end
end
