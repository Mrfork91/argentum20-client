Attribute VB_Name = "Mod_TileEngine"
'MENDUZ DX8 VERSION www.noicoder.com
'RevolucionAo 1.0
'Pablo Mercavides



Option Explicit


Public PreguntaScreen As String
Public Pregunta As Boolean
Public PreguntaLocal As Boolean
Public PreguntaNUM As Byte

'Map sizes in tiles
Public Const XMaxMapSize As Byte = 100
Public Const XMinMapSize As Byte = 1
Public Const YMaxMapSize As Byte = 100
Public Const YMinMapSize As Byte = 1

Private Const GrhFogata As Integer = 1521

''
'Sets a Grh animation to loop indefinitely.
Private Const INFINITE_LOOPS As Integer = -1

Public MaxGrh As Long

'Encabezado bmp
Type BITMAPFILEHEADER
    bfType As Integer
    bfSize As Long
    bfReserved1 As Integer
    bfReserved2 As Integer
    bfOffBits As Long
End Type

'Info del encabezado del bmp
Type BITMAPINFOHEADER
    biSize As Long
    biWidth As Long
    biHeight As Long
    biPlanes As Integer
    biBitCount As Integer
    biCompression As Long
    biSizeImage As Long
    biXPelsPerMeter As Long
    biYPelsPerMeter As Long
    biClrUsed As Long
    biClrImportant As Long
End Type

'Posicion en un mapa
Public Type Position
    x As Long
    y As Long
End Type

'Posicion en el Mundo
Public Type WorldPos
    map As Integer
    x As Integer
    y As Integer
End Type

'Contiene info acerca de donde se puede encontrar un grh tama�o y animacion
Public Type GrhData
    sX As Integer
    sY As Integer
    
    FileNum As Long
    
    
    pixelWidth As Integer
    pixelHeight As Integer
    
    TileWidth As Single
    TileHeight As Single
    
    NumFrames As Integer
    Frames() As Long 'gs-long
    speed As Single
    active As Boolean
    MiniMap_color As Long
End Type

'apunta a una estructura grhdata y mantiene la animacion
Public Type grh
    GrhIndex As Long
    framecounter As Single
    speed As Single
    Started As Byte
    Loops As Integer
    angle As Single
    AnimacionContador As Single
    CantAnim As Long
    Alpha As Byte
    FxIndex As Integer
End Type

'Lista de cuerpos
Public Type BodyData
    Walk(E_Heading.NORTH To E_Heading.WEST) As grh
    HeadOffset As Position
End Type

'Lista de cabezas
Public Type HeadData
    Head(E_Heading.NORTH To E_Heading.WEST) As grh
End Type

'Lista de las animaciones de las armas
Type WeaponAnimData
    WeaponWalk(E_Heading.NORTH To E_Heading.WEST) As grh
End Type

'Lista de las animaciones de los escudos
Type ShieldAnimData
    ShieldWalk(E_Heading.NORTH To E_Heading.WEST) As grh
End Type


'Apariencia del personaje
Public Type Char

    UserMinHp As Long
    UserMaxHp As Long
    
    EsEnano As Boolean
    active As Byte
    Heading As E_Heading
    Pos As Position
    
    NowPosX As Integer
    NowPosY As Integer
    
    iHead As Integer
    iBody As Integer
    Body As BodyData
    Head As HeadData
    Casco As HeadData
    Arma As WeaponAnimData
    Escudo As ShieldAnimData
    MovArmaEscudo As Boolean
    
    fX As grh
    FxIndex As Integer
    BarTime As Single
    Escribiendo As Boolean
    MaxBarTime As Integer
    BarAccion As Byte
    Particula As Byte
    
    ParticulaTime As Long
    
    Speeding As Single
    EsNpc As Boolean
    
    Donador As Byte
    appear As Byte
    simbolo As Byte

    Head_Aura As String
    Body_Aura As String
    Arma_Aura As String
    Escudo_Aura As String
    Otra_Aura As String

    AuraAngle As Single
    
    FxCount As Integer
    FxList() As grh
        
    particle_count As Integer
    CreandoCant As Integer
    particle_group() As Integer

    TimerM As Byte
    TimerAct As Boolean
    
    TimerI As Single
    TimerIAct As Boolean

    status As Byte
    
    nombre As String
    
    scrollDirectionX As Integer
    scrollDirectionY As Integer
    
    Moving As Byte
    MoveOffsetX As Single
    MoveOffsetY As Single
    
    pie As Boolean
    MUERTO As Boolean
    invisible As Boolean
    priv As Byte
    
    dialog As String
    dialog_offset_counter_y As Single
    dialog_scroll As Boolean
    AlphaText As Single
    AlphaPJ As Single
    dialog_color As Long
    dialog_life As Byte
    dialog_font_index As Integer
    
    dialogEfec As String
    SubeEfecto As Single
    dialog_Efect_color As ARGB
    
    dialogExp As String
    SubeExp As Single
    dialog_Exp_color As RGB
    
    dialogOro As String
    SubeOro As Single
    dialog_Oro_color As RGB
    
    group_index As Integer
    
    clan_index As Integer
    clan_nivel As Byte
End Type

'Info de un objeto
Public Type Obj
    OBJIndex As Integer
    Amount As Integer
End Type

'Tipo de las celdas del mapa
Public Type Light
    Rango As Integer
    color As Long
End Type




Public Type Fantasma
    Activo As Boolean
    Body As grh
    Head As grh
    Arma As grh
    Casco As grh
    Escudo As grh
    Body_Aura As String
    AlphaB As Single
    OffX As Integer
    Offy As Integer
    Heading As Byte
End Type

Public Type MapBlock
    fX As grh
    FxIndex As Byte
    
    
    
    FxCount As Integer
    FxList() As grh
    
    Graphic(1 To 4) As grh
    CharIndex As Integer
    ObjGrh As grh
    GrhBlend As Single
    light_value(3) As Long
    
    luz As Light
    particle_group As Integer
    particle_Index As Integer
    
    RenderValue As RVList
    
    NpcIndex As Integer
    OBJInfo As Obj
    TileExit As WorldPos
    Blocked As Byte
    
    Trigger As Integer
    CharFantasma As Fantasma
End Type



'Info de cada mapa
Public Type MapInfo
    Music As String
    name As String
    StartPos As WorldPos
    MapVersion As Integer
    Llueve As Byte
    Nieba As Byte
End Type

'DX7 Objects
'Public DirectX As New DirectX7
'Public DirectDraw As DirectDraw7
'Private PrimarySurface As DirectDrawSurface7
'Private PrimaryClipper As DirectDrawClipper
'Private BackBufferSurface As DirectDrawSurface7

Public IniPath As String
Public MapPath As String


'Bordes del mapa
Public MinXBorder As Byte
Public MaxXBorder As Byte
Public MinYBorder As Byte
Public MaxYBorder As Byte

'Status del user
Public CurMap As Integer 'Mapa actual
Public userindex As Integer
Public UserMoving As Byte
Public UserBody As Integer
Public UserHead As Integer
Public UserPos As Position 'Posicion
Public AddtoUserPos As Position 'Si se mueve
Public UserCharIndex As Integer

Public EngineRun As Boolean

Public fps As Long
Public FramesPerSecCounter As Long
Private fpsLastCheck As Long

'Tama�o del la vista en Tiles
Private WindowTileWidth As Integer
Private WindowTileHeight As Integer

Private HalfWindowTileWidth As Integer
Private HalfWindowTileHeight As Integer

'Offset del desde 0,0 del main view
Private MainViewTop As Integer
Private MainViewLeft As Integer

'Cuantos tiles el engine mete en el BUFFER cuando
'dibuja el mapa. Ojo un tama�o muy grande puede
'volver el engine muy lento
Public TileBufferSize As Integer

Private TileBufferPixelOffsetX As Integer
Private TileBufferPixelOffsetY As Integer

'Tama�o de los tiles en pixels
Public Const TilePixelHeight As Integer = 32
Public Const TilePixelWidth As Integer = 32

'Number of pixels the engine scrolls per frame. MUST divide evenly into pixels per tile
Public ScrollPixelsPerFrameX As Single
Public ScrollPixelsPerFrameY As Single

Dim timerElapsedTime As Single
Dim timerTicksPerFrame As Single
Dim engineBaseSpeed As Single


Public NumBodies As Integer
Public Numheads As Integer
Public NumFxs As Integer

Public NumChars As Integer
Public LastChar As Long
Public NumWeaponAnims As Integer
Public NumShieldAnims As Integer


Private MainDestRect   As RECT
Private MainViewRect   As RECT
Private BackBufferRect As RECT

Private MainViewWidth As Integer
Private MainViewHeight As Integer

Private MouseTileX As Byte
Private MouseTileY As Byte




'�?�?�?�?�?�?�?�?�?�Graficos�?�?�?�?�?�?�?�?�?�?�?
Public GrhData() As GrhData 'Guarda todos los grh
Public BodyData() As BodyData
Public HeadData() As HeadData
Public FxData() As tIndiceFx
Public WeaponAnimData() As WeaponAnimData
Public ShieldAnimData() As ShieldAnimData
Public CascoAnimData() As HeadData
'�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?

'�?�?�?�?�?�?�?�?�?�Mapa?�?�?�?�?�?�?�?�?�?�?�?
Public MapData() As MapBlock ' Mapa
Public MapInfo As MapInfo ' Info acerca del mapa en uso
'�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?

Public bRain        As Boolean 'est� raineando?
Public bNieve       As Boolean 'est� nevando?
Public bNiebla      As Boolean 'Hay niebla?
Public bTecho       As Boolean 'hay techo?
Public brstTick     As Long


Private iFrameIndex As Byte  'Frame actual de la LL
Private llTick      As Long  'Contador


Public charlist(1 To 10000) As Char

#If SeguridadAlkon Then

Public MI(1 To 1233) As clsManagerInvisibles
Public CualMI As Integer

#End If

' Used by GetTextExtentPoint32
Private Type size
    cx As Long
    cy As Long
End Type

'[CODE 001]:MatuX
Public Enum PlayLoop
    plNone = 0
    plLluviain = 1
    plLluviaout = 2
End Enum
'[END]'
'
'       [END]
'�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?



Private Declare Function BitBlt Lib "gdi32" (ByVal hDestDC As Long, ByVal x As Long, ByVal y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal hSrcDC As Long, ByVal xSrc As Long, ByVal ySrc As Long, ByVal dwRop As Long) As Long
Private Declare Function SelectObject Lib "gdi32" (ByVal hdc As Long, ByVal hObject As Long) As Long
Private Declare Function CreateCompatibleDC Lib "gdi32" (ByVal hdc As Long) As Long
Private Declare Function DeleteDC Lib "gdi32" (ByVal hdc As Long) As Long
Private Declare Function DeleteObject Lib "gdi32" (ByVal hObject As Long) As Long


'Added by Juan Mart�n Sotuyo Dodero
Private Declare Function StretchBlt Lib "gdi32" (ByVal hDestDC As Long, ByVal x As Long, ByVal y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal hSrcDC As Long, ByVal xSrc As Long, ByVal ySrc As Long, ByVal nSrcWidth As Long, ByVal nSrcHeight As Long, ByVal dwRop As Long) As Long
Private Declare Function SetPixel Lib "gdi32" (ByVal hdc As Long, ByVal x As Long, ByVal y As Long, ByVal crColor As Long) As Long
Private Declare Function GetPixel Lib "gdi32" (ByVal hdc As Long, ByVal x As Long, ByVal y As Long) As Long
'Added by Barrin


'Very percise counter 64bit system counter
Private Declare Function QueryPerformanceFrequency Lib "kernel32" (lpFrequency As Currency) As Long
Private Declare Function QueryPerformanceCounter Lib "kernel32" (lpPerformanceCount As Currency) As Long

'Text width computation. Needed to center text.
Private Declare Function GetTextExtentPoint32 Lib "gdi32" Alias "GetTextExtentPoint32A" (ByVal hdc As Long, ByVal lpsz As String, ByVal cbString As Long, lpSize As size) As Long



Sub ConvertCPtoTP(ByVal viewPortX As Integer, ByVal viewPortY As Integer, ByRef tX As Byte, ByRef tY As Byte)
'******************************************
'Converts where the mouse is in the main window to a tile position. MUST be called eveytime the mouse moves.
'******************************************
    
    If viewPortX < 0 Or viewPortX > frmmain.renderer.ScaleWidth Then Exit Sub
    If viewPortY < 0 Or viewPortY > frmmain.renderer.ScaleHeight Then Exit Sub

    tX = UserPos.x + viewPortX \ 32 - frmmain.renderer.ScaleWidth \ 64
    tY = UserPos.y + viewPortY \ 32 - frmmain.renderer.ScaleHeight \ 64

End Sub

Sub ResetCharInfo(ByVal CharIndex As Integer)

    With charlist(CharIndex)
    
        .active = 0
        .AlphaPJ = 0
        .Escribiendo = False
        .appear = 0
        .status = 0
        .invisible = False
        .Arma_Aura = ""
        .Body_Aura = ""
        .AuraAngle = 0
        .Head_Aura = ""
        .Speeding = 0
        .Otra_Aura = ""
        .Escudo_Aura = ""
        .Particula = 0
        .ParticulaTime = 0
        .particle_count = 0
        .FxCount = 0
        .CreandoCant = 0
        .Moving = 0
        .MUERTO = False
        .nombre = ""
        .pie = False
       ' .Pos.X = 0
        '.Pos.Y = 0
        
        .MovArmaEscudo = False
        .TimerAct = False
        .TimerM = 128
        .TimerI = 128
        .TimerIAct = False
        .dialog = ""
        .dialogExp = ""
        .dialogEfec = ""
        .dialogOro = ""
        .SubeExp = 0
        .group_index = 0
        .clan_index = 0
        .clan_nivel = 0
        .BarTime = 0
        .BarAccion = 0
        .MaxBarTime = 0
        .UserMaxHp = 0
        .UserMinHp = 0
        
    End With
    
End Sub
Sub MakeChar(ByVal CharIndex As Integer, ByVal Body As Integer, ByVal Head As Integer, ByVal Heading As Byte, ByVal x As Integer, ByVal y As Integer, ByVal Arma As Integer, ByVal Escudo As Integer, ByVal Casco As Integer, ByVal ParticulaFx As Byte, ByVal appear As Byte)
On Error Resume Next
    'Apuntamos al ultimo Char
   ' Debug.Print charindex
    If CharIndex > LastChar Then LastChar = CharIndex
    
    With charlist(CharIndex)
        'If the char wasn't allready active (we are rewritting it) don't increase char count
        If .active = 0 Then _
            NumChars = NumChars + 1
        
        If Arma = 0 Then Arma = 2
        If Escudo = 0 Then Escudo = 2
        If Casco = 0 Then Casco = 2
        
        .iHead = Head
        .iBody = Body
        
        .Head = HeadData(Head)
        .Body = BodyData(Body)
        .Arma = WeaponAnimData(Arma)
        
        .Escudo = ShieldAnimData(Escudo)
        .Casco = CascoAnimData(Casco)
        
        .Heading = Heading
        
        'Reset moving stats
        .Moving = 0
        .MoveOffsetX = 0
        .MoveOffsetY = 0
        
        'Update position
        .Pos.x = x
        .Pos.y = y
        
        'Make active
        .active = 1
        
        .AlphaPJ = 255
        
        If BodyData(Body).HeadOffset.y = -26 Then
        .EsEnano = True
        Else
        .EsEnano = False
        End If
   
        
        If .Particula = ParticulaFx Then
        ParticulaFx = 0
        End If
        
        If ParticulaFx <> 0 Then
        .Particula = ParticulaFx
            Call General_Char_Particle_Create(ParticulaFx, CharIndex, -1)
        End If
        


      
    End With
    
    'Plot on map
    MapData(x, y).CharIndex = CharIndex
End Sub
Sub EraseChar(ByVal CharIndex As Integer)
'*****************************************************************
'Erases a character from CharList and map
'*****************************************************************
    
    If CharIndex = 0 Then Exit Sub
    If charlist(CharIndex).active = 0 Then Exit Sub

    charlist(CharIndex).active = 0
    
    'Update lastchar
    If CharIndex = LastChar Then
        Do Until charlist(LastChar).active = 1
            LastChar = LastChar - 1
            If LastChar = 0 Then Exit Do
        Loop
    End If
    
    MapData(charlist(CharIndex).Pos.x, charlist(CharIndex).Pos.y).CharIndex = 0
    
    'Remove char's dialog
    Call Dialogos.RemoveDialog(CharIndex)
    
    Call ResetCharInfo(CharIndex)
    
    'Update NumChars
    NumChars = NumChars - 1
End Sub


Public Sub InitGrh(ByRef grh As grh, ByVal GrhIndex As Long, Optional ByVal Started As Byte = 2)
'*****************************************************************
'Sets up a grh. MUST be done before rendering
'*****************************************************************
    grh.GrhIndex = GrhIndex
    
    'Ladder Revisar
    
    If GrhIndex = 0 Then Exit Sub
    If Started = 2 Then
        If GrhData(grh.GrhIndex).NumFrames > 1 Then
            grh.Started = 1
            'Grh.speed = 0.9
            Else
            grh.Started = 0
        End If
    Else
        'Make sure the graphic can be started
        If grh.GrhIndex > MaxGrh Then Exit Sub
        If GrhData(grh.GrhIndex).NumFrames = 1 Then Started = 0
        grh.Started = Started
    End If
    
    
    If grh.Started Then
        grh.Loops = INFINITE_LOOPS
    Else
        grh.Loops = 0
    End If
    
    grh.framecounter = 1
    grh.speed = GrhData(grh.GrhIndex).speed
End Sub

Public Sub DoFogataFx()
    Dim location As Position
    
    If bFogata Then
        bFogata = HayFogata(location)
        If Not bFogata Then
           ' Call Audio.StopWave(FogataBufferIndex)
            FogataBufferIndex = 0
        End If
    Else
        bFogata = HayFogata(location)
       ' If bFogata And FogataBufferIndex = 0 Then FogataBufferIndex = Audio.PlayWave("fuego.wav", location.x, location.y, LoopStyle.Enabled)
    End If
End Sub

Private Function EstaPCarea(ByVal CharIndex As Integer) As Boolean
    With charlist(CharIndex).Pos
        EstaPCarea = .x > UserPos.x - MinXBorder And .x < UserPos.x + MinXBorder And .y > UserPos.y - MinYBorder And .y < UserPos.y + MinYBorder
    End With
End Function

Sub DoPasosFx(ByVal CharIndex As Integer)
Static TerrenoDePaso As TipoPaso
Static FileNum As Integer




    If Not UserNavegando Then
        With charlist(CharIndex)
           If Not .MUERTO And EstaPCarea(CharIndex) And (.priv = 0 Or .priv > 5) Then
           If .Speeding > 1.3 Then
                   
                    Call Sound.Sound_Play(Pasos(CONST_CABALLO).wav(1), , Sound.Calculate_Volume(.Pos.x, .Pos.y), Sound.Calculate_Pan(.Pos.x, .Pos.y))
                    Exit Sub
            End If
           
                .pie = Not .pie
                    If .pie Then
                    FileNum = GrhData(MapData(.Pos.x, .Pos.y).Graphic(1).GrhIndex).FileNum
                    TerrenoDePaso = GetTerrenoDePaso(FileNum)
                        Call Sound.Sound_Play(Pasos(TerrenoDePaso).wav(1), , Sound.Calculate_Volume(.Pos.x, .Pos.y), Sound.Calculate_Pan(.Pos.x, .Pos.y))
                        'Call Audio.PlayWave(SND_PASOS3, .Pos.X, .Pos.Y)
                    Else
                         Call Sound.Sound_Play(Pasos(TerrenoDePaso).wav(2), , Sound.Calculate_Volume(.Pos.x, .Pos.y), Sound.Calculate_Pan(.Pos.x, .Pos.y))
                    End If
            End If
        End With
    Else

    If FxNavega Then
        Call Sound.Sound_Play(SND_NAVEGANDO)
      '  Call Audio.PlayWave(SND_NAVEGANDO, charlist(charindex).Pos.x, charlist(charindex).Pos.y)
    End If
    End If
End Sub
Private Function GetTerrenoDePaso(ByVal TerrainFileNum As Integer) As TipoPaso


If (TerrainFileNum >= 6000 And TerrainFileNum <= 6004) Or (TerrainFileNum >= 550 And TerrainFileNum <= 552) Or (TerrainFileNum >= 6018 And TerrainFileNum <= 6020) Then
    GetTerrenoDePaso = CONST_BOSQUE
    Exit Function
ElseIf (TerrainFileNum >= 7501 And TerrainFileNum <= 7507) Or (TerrainFileNum = 7500 Or TerrainFileNum = 7508 Or TerrainFileNum = 1533 Or TerrainFileNum = 2508) Then
    GetTerrenoDePaso = CONST_DUNGEON
    Exit Function
ElseIf (TerrainFileNum >= 5000 And TerrainFileNum <= 5004) Then
    GetTerrenoDePaso = CONST_NIEVE
    Exit Function
ElseIf (TerrainFileNum >= 6018 And TerrainFileNum <= 6021) Or (TerrainFileNum = 186 Or TerrainFileNum = 8007) Then
    GetTerrenoDePaso = CONST_DESIERTO
    Exit Function
Else
    GetTerrenoDePaso = CONST_PISO
End If

End Function
Sub MoveCharbyPos(ByVal CharIndex As Integer, ByVal nX As Integer, ByVal nY As Integer)
On Error Resume Next
    Dim x As Integer
    Dim y As Integer
    Dim addx As Integer
    Dim addy As Integer
    Dim nHeading As E_Heading
    
    With charlist(CharIndex)
        x = .Pos.x
        y = .Pos.y
        
        MapData(x, y).CharIndex = 0
        
        addx = nX - x
        addy = nY - y
        
        If Sgn(addx) = 1 Then
            nHeading = E_Heading.EAST
        End If
        
        If Sgn(addx) = -1 Then
            nHeading = E_Heading.WEST
        End If
        
        If Sgn(addy) = -1 Then
            nHeading = E_Heading.NORTH
        End If
        
        If Sgn(addy) = 1 Then
            nHeading = E_Heading.south
        End If
        
        MapData(nX, nY).CharIndex = CharIndex
        
        
        .Pos.x = nX
        .Pos.y = nY
        
        .MoveOffsetX = -1 * (TilePixelWidth * addx)
        .MoveOffsetY = -1 * (TilePixelHeight * addy)
        
        .Moving = 1
        .Heading = nHeading
        
        .scrollDirectionX = Sgn(addx)
        .scrollDirectionY = Sgn(addy)
        

    End With
    
    If Not EstaPCarea(CharIndex) Then Call Dialogos.RemoveDialog(CharIndex)
    
    If (nY < MinLimiteY) Or (nY > MaxLimiteY) Or (nX < MinLimiteX) Or (nX > MaxLimiteX) Then
        Call EraseChar(CharIndex)
    End If
End Sub

Sub MoveScreen(ByVal nHeading As E_Heading)

'******************************************
'Starts the screen moving in a direction
'******************************************
    Dim x As Integer
    Dim y As Integer
    Dim tX As Integer
    Dim tY As Integer
    
    'Figure out which way to move
    Select Case nHeading
        Case E_Heading.NORTH
            y = -1
        
        Case E_Heading.EAST
            x = 1
        
        Case E_Heading.south
            y = 1
        
        Case E_Heading.WEST
            x = -1
    End Select
    
    'Fill temp pos
    tX = UserPos.x + x
    tY = UserPos.y + y
    
    'Check to see if its out of bounds
    If tX < MinXBorder Or tX > MaxXBorder Or tY < MinYBorder Or tY > MaxYBorder Then
        Exit Sub
    Else
        'Start moving... MainLoop does the rest
        AddtoUserPos.x = x
        UserPos.x = tX
        AddtoUserPos.y = y
        UserPos.y = tY
        UserMoving = 1
        
        bTecho = IIf(MapData(UserPos.x, UserPos.y).Trigger = 1 Or _
                MapData(UserPos.x, UserPos.y).Trigger = 2 Or _
                MapData(UserPos.x, UserPos.y).Trigger = 6 Or _
                MapData(UserPos.x, UserPos.y).Trigger > 9 Or _
                MapData(UserPos.x, UserPos.y).Trigger = 4, True, False)
    End If
End Sub

Public Function HayFogata(ByRef location As Position) As Boolean
    Dim j As Long
    Dim k As Long
    
    For j = UserPos.x - 13 To UserPos.x + 13
        For k = UserPos.y - 15 To UserPos.y + 15
            If InMapBounds(j, k) Then
                If MapData(j, k).ObjGrh.GrhIndex = GrhFogata Then
                    location.x = j
                    location.y = k
                    
                    HayFogata = True
                    Exit Function
                End If
            End If
        Next k
    Next j
End Function
Public Function HayWavAmbiental(ByRef location As Position) As Boolean
    Dim j As Long
    Dim k As Long
    
    For j = UserPos.x - 13 To UserPos.x + 13
        For k = UserPos.y - 15 To UserPos.y + 15
            If InMapBounds(j, k) Then
                If MapData(j, k).Trigger = 150 Then
                    location.x = j
                    location.y = k
                    
                  '  HayFogata = True
                '    Exit Function
                End If
            End If
        Next k
    Next j
End Function

Function NextOpenChar() As Integer
'*****************************************************************
'Finds next open char slot in CharList
'*****************************************************************
    Dim loopc As Long
    Dim Dale As Boolean
    
    loopc = 1
    Do While charlist(loopc).active And Dale
        loopc = loopc + 1
        Dale = (loopc <= UBound(charlist))
    Loop
    
    NextOpenChar = loopc
End Function

''
' Loads grh data using the new file format.
'
' @return   True if the load was successfull, False otherwise.


Function LegalPos(ByVal x As Integer, ByVal y As Integer) As Boolean
'*****************************************************************
'Checks to see if a tile position is legal
'*****************************************************************
    'Limites del mapa
    If x < MinXBorder Or x > MaxXBorder Or y < MinYBorder Or y > MaxYBorder Then
        Exit Function
    End If
    
    'Tile Bloqueado?
    If MapData(x, y).Blocked = 1 Then
        Exit Function
    End If
    
    '�Hay un personaje?
    If MapData(x, y).CharIndex > 0 Then
    If charlist(MapData(x, y).CharIndex).MUERTO Then
    Else
        Exit Function
    End If

    End If

    'If Not UserNadando And MapData(x, y).Trigger = 8 Then
               ' If Not UserAvisado Then
                  '  Call AddtoRichTextBox(frmMain.RecTxt, "El terreno es rocoso y tu barca podria romperse, solo puedes nadar.", 65, 190, 156, False, False, False)
                   ' UserAvisado = True
               ' End If
        'Exit Function

    'Else
   ' If UserNadando And MapData(x, y).Trigger <> 8 Then
   ' Exit Function
   ' End If
       ' LegalPos = True
       ' Exit Function
  '  End If
    
    
    If UserMontado And MapData(x, y).Trigger > 9 Then
        Exit Function
    End If
    '
    If UserNadando And MapData(x, y).Trigger = 8 Then
        LegalPos = True
        Exit Function
    End If
   
   If UserNavegando <> HayAgua(x, y) Then
        Exit Function
    End If
    
    If UserNavegando And MapData(x, y).Trigger = 8 And Not UserNadando And Not UserEstado = 1 Then
        If Not UserAvisadoBarca Then
            Call AddtoRichTextBox(frmmain.RecTxt, "�Atenci�n! El terreno es rocoso y tu barca podria romperse, solo puedes nadar.", 255, 255, 255, True, False, False)
            UserAvisadoBarca = True
        End If
        Exit Function
    End If
    
   'If UserNadando <> HayAgua(x, y) Then
    '    Exit Function
    'End If
    
    UserAvisadoBarca = False
    LegalPos = True
    UserAvisado = False
End Function

Function InMapBounds(ByVal x As Integer, ByVal y As Integer) As Boolean
'*****************************************************************
'Checks to see if a tile position is in the maps bounds
'*****************************************************************
    If x < XMinMapSize Or x > XMaxMapSize Or y < YMinMapSize Or y > YMaxMapSize Then
        Exit Function
    End If
    
    InMapBounds = True
End Function





Function GetBitmapDimensions(ByVal BmpFile As String, ByRef bmWidth As Long, ByRef bmHeight As Long)
'*****************************************************************
'Gets the dimensions of a bmp
'*****************************************************************
    Dim BMHeader As BITMAPFILEHEADER
    Dim BINFOHeader As BITMAPINFOHEADER
    
    Open BmpFile For Binary Access Read As #1
    
    Get #1, , BMHeader
    Get #1, , BINFOHeader
    
    Close #1
    
    bmWidth = BINFOHeader.biWidth
    bmHeight = BINFOHeader.biHeight
End Function
Public Sub Grh_Render_To_Hdc(ByRef pic As PictureBox, ByVal GrhIndex As Long, ByVal screen_x As Integer, ByVal screen_y As Integer, Optional ByVal Alpha As Integer = False)


If GrhIndex = 0 Then Exit Sub

'Public Sub Draw_Grh_Picture(ByVal grh As Long, ByVal pic As PictureBox, _
                            ByVal X As Integer, ByVal Y As Integer, _
                            ByVal alpha As Boolean, ByVal angle As Single, _
                            Optional ByVal ModSizeX2 As Byte = 0, Optional ByVal color As Long = -1)

Static Piture As RECT
    With Piture
        .Left = 0
        .Top = 0
        

        .bottom = pic.ScaleHeight
        .Right = pic.ScaleWidth
    End With
    Dim s(3) As Long
    s(0) = -1
    s(1) = -1
    s(2) = -1
    s(3) = -1

    D3DDevice.Clear 0, ByVal 0, D3DCLEAR_TARGET, 0, 0, 0
    D3DDevice.BeginScene
         engine.Device_Box_Textured_Render GrhIndex, screen_x, screen_y, _
                        GrhData(GrhIndex).pixelWidth, GrhData(GrhIndex).pixelHeight, _
                        s, GrhData(GrhIndex).sX, GrhData(GrhIndex).sY, Alpha, 0
                           
    D3DDevice.EndScene
    D3DDevice.Present Piture, ByVal 0, pic.hwnd, ByVal 0
    
    
End Sub
Public Sub Grh_Render_To_HdcSinBorrar(ByRef pic As PictureBox, ByVal GrhIndex As Long, ByVal screen_x As Integer, ByVal screen_y As Integer, Optional ByVal Alpha As Integer = False)


If GrhIndex = 0 Then Exit Sub

'Public Sub Draw_Grh_Picture(ByVal grh As Long, ByVal pic As PictureBox, _
                            ByVal X As Integer, ByVal Y As Integer, _
                            ByVal alpha As Boolean, ByVal angle As Single, _
                            Optional ByVal ModSizeX2 As Byte = 0, Optional ByVal color As Long = -1)

Static Piture As RECT
    With Piture
        .Left = 0
        .Top = 0
        

        .bottom = pic.ScaleHeight
        .Right = pic.ScaleWidth
    End With
    Dim s(3) As Long
    s(0) = -1
    s(1) = -1
    s(2) = -1
    s(3) = -1

    'D3DDevice.Clear 0, ByVal 0, D3DCLEAR_TARGET, 0, 0, 0
    D3DDevice.BeginScene
         engine.Device_Box_Textured_Render GrhIndex, screen_x, screen_y, _
                        GrhData(GrhIndex).pixelWidth, GrhData(GrhIndex).pixelHeight, _
                        s, GrhData(GrhIndex).sX, GrhData(GrhIndex).sY, Alpha, 0
                           
    D3DDevice.EndScene
    D3DDevice.Present Piture, ByVal 0, pic.hwnd, ByVal 0
    
    
End Sub
Public Sub Draw_Grh_Picture(ByVal grh As Long, ByVal pic As PictureBox, _
                            ByVal x As Integer, ByVal y As Integer, _
                            ByVal Alpha As Boolean, ByVal angle As Single, _
                            Optional ByVal ModSizeX2 As Byte = 0, Optional ByVal color As Long = -1)
'**************************************************************
'Author: Mannakia
'Last Modify Date: 14/05/2009
'Modificado hoy(?) agregue funcion de agrandar y achicar para ladder :P
'**************************************************************

Static Piture As RECT
    With Piture
        .Left = 0
        .Top = 0
        
    If ModSizeX2 = 1 Then
        .bottom = pic.ScaleHeight / 2
        .Right = pic.ScaleWidth / 2
    ElseIf ModSizeX2 = 2 Then
        .bottom = pic.ScaleHeight * 2
        .Right = pic.ScaleWidth * 2
    Else
        .bottom = pic.ScaleHeight
        .Right = pic.ScaleWidth
    End If
        
    End With
    Dim s(3) As Long
    s(0) = color
    s(1) = color
    s(2) = color
    s(3) = color


    D3DDevice.Clear 0, ByVal 0, D3DCLEAR_TARGET, 0, 0, 0
    D3DDevice.BeginScene
         engine.Device_Box_Textured_Render grh, x, y, _
                        GrhData(grh).pixelWidth, GrhData(grh).pixelHeight, _
                        s, GrhData(grh).sX, GrhData(grh).sY, Alpha, angle
                           
    D3DDevice.EndScene
    D3DDevice.Present Piture, ByVal 0, pic.hwnd, ByVal 0

End Sub




Public Function RenderSounds()
'**************************************************************
'Author: Juan Mart�n Sotuyo Dodero
'Last Modify Date: 3/30/2008
'Actualiza todos los sonidos del mapa.
'**************************************************************
    If bRain Then
        If MapDat.LLUVIA Then
        
            If bTecho Then
                If frmmain.IsPlaying <> PlayLoop.plLluviain Then
                  '  If RainBufferIndex Then _
                     '   Call Audio.StopWave(RainBufferIndex)
                   ' RainBufferIndex = Audio.PlayWave("lluviain.wav", 0, 0, LoopStyle.Enabled)
                    frmmain.IsPlaying = PlayLoop.plLluviain
                End If
            Else
                If frmmain.IsPlaying <> PlayLoop.plLluviaout Then
                
                   ' If RainBufferIndex Then _
                     '   Call Audio.StopWave(RainBufferIndex)
                  '  RainBufferIndex = Audio.PlayWave("lluviaout.wav", 0, 0, LoopStyle.Enabled)
                    frmmain.IsPlaying = PlayLoop.plLluviaout
                End If
            End If
        End If
    End If
    
    
    DoFogataFx
End Function

Function HayUserAbajo(ByVal x As Integer, ByVal y As Integer, ByVal GrhIndex As Long) As Boolean
    If GrhIndex > 0 Then
        HayUserAbajo = _
            charlist(UserCharIndex).Pos.x >= x - (GrhData(GrhIndex).TileWidth \ 2) _
                And charlist(UserCharIndex).Pos.x <= x + (GrhData(GrhIndex).TileWidth \ 2) _
                And charlist(UserCharIndex).Pos.y >= y - (GrhData(GrhIndex).TileHeight - 1) _
                And charlist(UserCharIndex).Pos.y <= y
    End If
End Function




Private Function GetElapsedTime() As Single
'**************************************************************
'Author: Aaron Perkins
'Last Modify Date: 10/07/2002
'Gets the time that past since the last call
'**************************************************************
    Dim Start_Time As Currency
    Static end_time As Currency
    Static timer_freq As Currency

    'Get the timer frequency
    If timer_freq = 0 Then
        QueryPerformanceFrequency timer_freq
    End If
    
    'Get current time
    Call QueryPerformanceCounter(Start_Time)
    
    'Calculate elapsed time
    GetElapsedTime = (Start_Time - end_time) / timer_freq * 1000
    
    'Get next end time
    Call QueryPerformanceCounter(end_time)
End Function
Public Sub SetCharacterFx(ByVal CharIndex As Integer, ByVal fX As Integer, ByVal Loops As Integer)

If fX = 0 Then Exit Sub
'***************************************************
'Author: Juan Mart�n Sotuyo Dodero (Maraxus)
'Last Modify Date: 12/03/04
'Sets an FX to the character.
'***************************************************
Dim indice As Byte
    With charlist(CharIndex)
    
    indice = engine.Char_FX_Group_Next_Open(CharIndex)
    .FxList(indice).FxIndex = fX
    Call InitGrh(.FxList(indice), FxData(fX).Animacion)
    .FxList(indice).Loops = Loops
            
    End With
End Sub
Private Sub Grh_Create_Mask(ByRef hdcsrc As Long, ByRef MaskDC As Long, ByVal src_x As Integer, ByVal src_y As Integer, ByVal src_width As Integer, ByVal src_height As Integer)
'**************************************************************
'Author: Juan Mart�n Sotuyo Dodero
'Last Modify Date: 8/30/2004
'Creates a Mask hDC, and sets the source hDC to work for trans bliting.
'**************************************************************
    Dim x As Integer
    Dim y As Integer
    Dim TransColor As Long
    Dim ColorKey As String
    
    'ColorKey = hex(COLOR_KEY)
    
    'Check if it has an alpha component
    'If Len(ColorKey) > 6 Then
         'get rid of alpha
    '    ColorKey = "&H" & Right$(ColorKey, 6)
    'End If
    'piluex prueba
    'TransColor = Val(ColorKey)
    ColorKey = "0"
    TransColor = &H0

    'Make it a mask (set background to black and foreground to white)
    'And set the sprite's background white
    For y = src_y To src_height + src_y
        For x = src_x To src_width + src_x
            If GetPixel(hdcsrc, x, y) = TransColor Then
                SetPixel MaskDC, x, y, vbWhite
                SetPixel hdcsrc, x, y, vbBlack
            Else
                SetPixel MaskDC, x, y, vbBlack
            End If
        Next x
    Next y
End Sub



