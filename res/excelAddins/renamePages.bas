Attribute VB_Name = "renamePages"
Sub getPageNames()
    
    ' init variables for function
    Dim ws As Worksheet
    Dim lRow As Long
    
    Worksheets.Add(Before:=Worksheets(1)).Name = "RenameSheets"
    
    Sheets("RenameSheets").Activate

    ' name the table columns for user to change names
    Cells(1, 1) = "CurrentNames"
    Cells(1, 2) = "RenameTo"
    Cells(1, 3) = "isNameValid"
    
    ' copy the values of all the sheets and put them on column 1=A
    For i = 2 To Sheets.Count
     Cells(i, 1) = Sheets(i).Name
    Next i
    
    ' do some formating
    Range("A1:C1").Select
    Selection.Font.Bold = True
    Columns("A:C").Select
    Selection.ColumnWidth = 31.4
    Range("A1:C1").Select
    With Selection
        .HorizontalAlignment = xlCenter
        .VerticalAlignment = xlBottom
        .WrapText = False
        .Orientation = 0
        .AddIndent = False
        .IndentLevel = 0
        .ShrinkToFit = False
        .ReadingOrder = xlContext
        .MergeCells = False
    End With
    
    
    ' get the value of the number of rows
    lRow = Cells(Rows.Count, 1).End(xlUp).Row
    
    ' forumula is separated in 3 instances as normal excel files wont handle full nesting (long formula)
    ' original formula in worksheet (it should be one line only)
    '=IFERROR(AND(MOD(MATCH(CODE(LEFT(B2,1)),{0,65,91,97,123}),2)=0,
    '(SUMPRODUCT(--(MOD(MATCH(CODE(MID(B2,ROW(INDIRECT("1:"&LEN(B2))),1)),
    '{0,48,58,65,91,95,96,97,123}),2)=0)))=LEN(B2)), FALSE())
    
    ' make sure that all characters are ok
    Range("D2").Select
    ActiveCell.FormulaR1C1 = _
        "=(SUMPRODUCT(--(MOD(MATCH(CODE(MID(RC[-2],ROW(INDIRECT(""1:""&LEN(RC[-2]))),1)),{0,48,58,65,91,95,96,97,123}),2)=0)))=LEN(RC[-2])"
    Selection.AutoFill Destination:=Range(Cells(2, 4), Cells(lRow, 4)), Type:=xlFillDefault
    
    ' make sure the first character is valid
    Range("E2").Select
    ActiveCell.FormulaR1C1 = _
        "=MOD(MATCH(CODE(LEFT(RC[-3],1)),{0,65,91,97,123}),2)=0"
    Selection.AutoFill Destination:=Range(Cells(2, 5), Cells(lRow, 5)), Type:=xlFillDefault

    ' AND both checks and handle error
    Range("C2").Select
    ActiveCell.FormulaR1C1 = "=IFERROR(AND(RC[1],RC[2]), FALSE())"
    Selection.AutoFill Destination:=Range(Cells(2, 3), Cells(lRow, 3)), Type:=xlFillDefault
    
    ' hide columns D and E
    Columns("D:E").Select
    Selection.EntireColumn.Hidden = True
    
    ' aplly conditional formating to the validity fields
    Range("C2").Select
    Range(Selection, Selection.End(xlDown)).Select
    Selection.FormatConditions.Add Type:=xlCellValue, Operator:=xlEqual, _
        Formula1:="=TRUE"
    Selection.FormatConditions(Selection.FormatConditions.Count).SetFirstPriority
    With Selection.FormatConditions(1).Font
        .Color = -16752384
        .TintAndShade = 0
    End With
    With Selection.FormatConditions(1).Interior
        .PatternColorIndex = xlAutomatic
        .Color = 13561798
        .TintAndShade = 0
    End With
    Selection.FormatConditions(1).StopIfTrue = False
    Selection.FormatConditions.Add Type:=xlCellValue, Operator:=xlEqual, _
        Formula1:="=FALSE"
    Selection.FormatConditions(Selection.FormatConditions.Count).SetFirstPriority
    
    With Selection.FormatConditions(1).Font
        .Color = -16383844
        .TintAndShade = 0
    End With
    
    With Selection.FormatConditions(1).Interior
        .PatternColorIndex = xlAutomatic
        .Color = 13551615
        .TintAndShade = 0
    End With
    Selection.FormatConditions(1).StopIfTrue = False
    
    ' create a message to tell the user the instructions for valid names
    Range("H2:O7").Select
    With Selection
        .HorizontalAlignment = xlCenter
        .VerticalAlignment = xlBottom
        .WrapText = False
        .Orientation = 0
        .AddIndent = False
        .IndentLevel = 0
        .ShrinkToFit = False
        .ReadingOrder = xlContext
        .MergeCells = False
    End With
    Selection.Merge
    With Selection
        .HorizontalAlignment = xlCenter
        .VerticalAlignment = xlCenter
        .WrapText = False
        .Orientation = 0
        .AddIndent = False
        .IndentLevel = 0
        .ShrinkToFit = False
        .ReadingOrder = xlContext
        .MergeCells = True
    End With
    With Selection
        .HorizontalAlignment = xlLeft
        .VerticalAlignment = xlCenter
        .WrapText = False
        .Orientation = 0
        .AddIndent = False
        .IndentLevel = 0
        .ShrinkToFit = False
        .ReadingOrder = xlContext
        .MergeCells = True
    End With
    Range("H2:O7").Select
    ActiveCell.FormulaR1C1 = _
        "Rules:" & Chr(10) & "- Names can only start with a-z or A-Z" _
                 & Chr(10) & "- Valid characters are only a-z, A-Z, 0-9 and underscore _" _
                 & Chr(10) & "- Try to use camelCase when possible: myVariableOne, thisIsATest" _
                 & Chr(10) & "- If you need decimals like 2.345 or 0.04 do: 2p345 and 0p04 instead"
    
    
    ' select the cell to start input from user
    Range("B2").Select
    
End Sub

Sub renamePagesTo()
    
    ' declare function variables
    Dim lRow As Long
    ' all the rows in array
    lRow = Cells(Rows.Count, 1).End(xlUp).Row
    
    ' select range of true falses and find if there is a non true value
    Range(Cells(2, 3), Cells(lRow, 3)).Select
    nontruefound = False
    For Each c In Selection
        If c.Value <> "True" Then
            nontruefound = True
        End If
    Next c
    
    ' frist make sure that this is was created with previous macro
    If (StrComp(Sheets(1).Name, "RenameSheets", vbTextCompare) = 1) Then
        MsgBox "To use this macro, first use Get Page Names Macro"
        Range("A1").Select
        
    ' make sure that all of the inputs generate a valid name
    ElseIf nontruefound Then
        MsgBox "All Names need to be Valid"
        Range("A1").Select
        
    ' if all is good, then rename the sheets, and delete this one
    Else
         
        For i = 2 To Sheets.Count
            Sheets(i).Name = Cells(i, 2)
        Next i

        Sheets(2).Activate
        Application.DisplayAlerts = False
        Sheets(1).Delete
        Application.DisplayAlerts = True
            
    End If
    
End Sub

Sub renameFilesCat()
'
' renameFilesCat Macro

    'change column widths and format
    Rows("1:1").Select
    Selection.Insert Shift:=xlDown, CopyOrigin:=xlFormatFromLeftOrAbove
    Columns("A:B").ColumnWidth = 62
    Range("A1").Select
    ActiveCell.FormulaR1C1 = "Original File Name"
    Range("B1").Select
    ActiveCell.FormulaR1C1 = "New File Name"
    Range("C1").Select
    ActiveCell.FormulaR1C1 = "cat1"
    Range("D1").Select
    ActiveCell.FormulaR1C1 = "cat2"
    Range("E1").Select
    ActiveCell.FormulaR1C1 = "cat3"
    Range("F1").Select
    ActiveCell.FormulaR1C1 = "cat4"
    Range("G1").Select
    ActiveCell.FormulaR1C1 = "cat5"
    Range("H1").Select
    ActiveCell.FormulaR1C1 = "cat6"
    Range("I1").Select
    ActiveCell.FormulaR1C1 = "cat7"
    Range("J1").Select
    ActiveCell.FormulaR1C1 = "cat8"
    Range("K1").Select
    ActiveCell.FormulaR1C1 = "cat9"
    Range("L1").Select
    ActiveCell.FormulaR1C1 = "cat10"
    Range("M1").Select
    ActiveCell.FormulaR1C1 = "cat11"
    Range("N1").Select
    ActiveCell.FormulaR1C1 = "ext"
    Range("O1").Select
    ActiveCell.FormulaR1C1 = "cmd"

    'merge first two rows
    Rows("2:2").Select
    Selection.Insert Shift:=xlDown, CopyOrigin:=xlFormatFromLeftOrAbove
    Range("A1:A2").Select
    With Selection
        .HorizontalAlignment = xlCenter
        .VerticalAlignment = xlCenter
        .WrapText = False
        .Orientation = 0
        .AddIndent = False
        .IndentLevel = 0
        .ShrinkToFit = False
        .ReadingOrder = xlContext
        .MergeCells = False
    End With
    Selection.Merge
    Range("B1:B2").Select
    With Selection
        .HorizontalAlignment = xlCenter
        .VerticalAlignment = xlCenter
        .WrapText = False
        .Orientation = 0
        .AddIndent = False
        .IndentLevel = 0
        .ShrinkToFit = False
        .ReadingOrder = xlContext
        .MergeCells = False
    End With
    Selection.Merge
    
    'add borders
    With ActiveSheet
        Lastrow = .Cells(.Rows.Count, "A").End(xlUp).Row
    End With
    
    Range("A1:A" & Lastrow).Select
    Range(Selection, Selection.End(xlToRight)).Select
    Selection.Borders(xlDiagonalDown).LineStyle = xlNone
    Selection.Borders(xlDiagonalUp).LineStyle = xlNone
    With Selection.Borders(xlEdgeLeft)
        .LineStyle = xlContinuous
        .ColorIndex = 0
        .TintAndShade = 0
        .Weight = xlThin
    End With
    With Selection.Borders(xlEdgeTop)
        .LineStyle = xlContinuous
        .ColorIndex = 0
        .TintAndShade = 0
        .Weight = xlThin
    End With
    With Selection.Borders(xlEdgeBottom)
        .LineStyle = xlContinuous
        .ColorIndex = 0
        .TintAndShade = 0
        .Weight = xlThin
    End With
    With Selection.Borders(xlEdgeRight)
        .LineStyle = xlContinuous
        .ColorIndex = 0
        .TintAndShade = 0
        .Weight = xlThin
    End With
    With Selection.Borders(xlInsideVertical)
        .LineStyle = xlContinuous
        .ColorIndex = 0
        .TintAndShade = 0
        .Weight = xlThin
    End With
    With Selection.Borders(xlInsideHorizontal)
        .LineStyle = xlContinuous
        .ColorIndex = 0
        .TintAndShade = 0
        .Weight = xlThin
    End With
    Range("A1:A2").Select
    
    'format
    Range("A1:A2").Select
    Range(Selection, Selection.End(xlToRight)).Select
    With Selection.Interior
        .Pattern = xlSolid
        .PatternColorIndex = xlAutomatic
        .ThemeColor = xlThemeColorAccent1
        .TintAndShade = 0.599993896298105
        .PatternTintAndShade = 0
    End With
    With Selection
        .HorizontalAlignment = xlCenter
        .WrapText = False
        .Orientation = 0
        .AddIndent = False
        .IndentLevel = 0
        .ShrinkToFit = False
        .ReadingOrder = xlContext
    End With
    
    'add checkboxes
    ActiveSheet.CheckBoxes.Add((722 + 51 * 0), 14, 50, 50).Select
    Application.CutCopyMode = False
    With Selection
        .Value = False
        .LinkedCell = "$C$2"
        .Display3DShading = False
        .Text = ""
        .Width = 15
        .Height = 15
        .Name = "delm1"
    End With
    ActiveSheet.CheckBoxes.Add((722 + 51 * 1), 14, 50, 50).Select
    Application.CutCopyMode = False
    With Selection
        .Value = False
        .LinkedCell = "$D$2"
        .Display3DShading = False
        .Text = ""
        .Width = 15
        .Height = 15
        .Name = "delm2"
    End With
    ActiveSheet.CheckBoxes.Add((722 + 51 * 2), 14, 50, 50).Select
    Application.CutCopyMode = False
    With Selection
        .Value = False
        .LinkedCell = "$E$2"
        .Display3DShading = False
        .Text = ""
        .Width = 15
        .Height = 15
        .Name = "delm3"
    End With
    ActiveSheet.CheckBoxes.Add((722 + 51 * 3), 14, 50, 50).Select
    Application.CutCopyMode = False
    With Selection
        .Value = False
        .LinkedCell = "$F$2"
        .Display3DShading = False
        .Text = ""
        .Width = 15
        .Height = 15
        .Name = "delm4"
    End With
    ActiveSheet.CheckBoxes.Add((722 + 51 * 4), 14, 50, 50).Select
    Application.CutCopyMode = False
    With Selection
        .Value = False
        .LinkedCell = "$G$2"
        .Display3DShading = False
        .Text = ""
        .Width = 15
        .Height = 15
        .Name = "delm5"
    End With
    ActiveSheet.CheckBoxes.Add((722 + 51 * 5), 14, 50, 50).Select
    Application.CutCopyMode = False
    With Selection
        .Value = False
        .LinkedCell = "$H$2"
        .Display3DShading = False
        .Text = ""
        .Width = 15
        .Height = 15
        .Name = "delm6"
    End With
    ActiveSheet.CheckBoxes.Add((722 + 51 * 6), 14, 50, 50).Select
    Application.CutCopyMode = False
    With Selection
        .Value = False
        .LinkedCell = "$I$2"
        .Display3DShading = False
        .Text = ""
        .Width = 15
        .Height = 15
        .Name = "delm7"
    End With
    ActiveSheet.CheckBoxes.Add((722 + 51 * 7), 14, 50, 50).Select
    Application.CutCopyMode = False
    With Selection
        .Value = False
        .LinkedCell = "$J$2"
        .Display3DShading = False
        .Text = ""
        .Width = 15
        .Height = 15
        .Name = "delm8"
    End With
    ActiveSheet.CheckBoxes.Add((722 + 51 * 8), 14, 50, 50).Select
    Application.CutCopyMode = False
    With Selection
        .Value = False
        .LinkedCell = "$K$2"
        .Display3DShading = False
        .Text = ""
        .Width = 15
        .Height = 15
        .Name = "delm9"
    End With
    ActiveSheet.CheckBoxes.Add((722 + 51 * 9), 14, 50, 50).Select
    Application.CutCopyMode = False
    With Selection
        .Value = False
        .LinkedCell = "$L$2"
        .Display3DShading = False
        .Text = ""
        .Width = 15
        .Height = 15
        .Name = "delm10"
    End With
    ActiveSheet.CheckBoxes.Add((722 + 51 * 10), 14, 50, 50).Select
    Application.CutCopyMode = False
    With Selection
        .Value = False
        .LinkedCell = "$M$2"
        .Display3DShading = False
        .Text = ""
        .Width = 15
        .Height = 15
        .Name = "delm11"
    End With
    
    
    
    'add formulas
    Range("B3").Select
    ActiveCell.FormulaR1C1 = _
        "=CONCAT(RC[1],IF(R2C3, ""_"",""""),RC[2],IF(R2C4, ""_"",""""),RC[3],IF(R2C5, ""_"",""""),RC[4],IF(R2C6, ""_"",""""),RC[5],IF(R2C7, ""_"",""""),RC[6],IF(R2C8, ""_"",""""),RC[7],IF(R2C9, ""_"",""""),RC[8],IF(R2C10, ""_"",""""),RC[9],IF(R2C11, ""_"",""""),RC[10],IF(R2C12, ""_"",""""),RC[11],IF(R2C13, ""_"",""""),RC[12])"
    Range("B3").Select
    
    Selection.AutoFill Destination:=Range("B3:B" & Lastrow)
    
    
    'split window to make it easy to read
    Range("B3").Select
    With ActiveWindow
        .SplitColumn = 1
        .SplitRow = 2
    End With
    
    'get command
    Range("O3").Select
    Application.CutCopyMode = False
    ActiveCell.FormulaR1C1 = _
        "=CONCAT(""ren"",CHAR(32),CHAR(34),RC[-14],CHAR(34),CHAR(32),RC[-13],CHAR(32),""&&^"")"
    Selection.AutoFill Destination:=Range("O3:O" & Lastrow)
    Range("O3:O" & Lastrow).Select
    
End Sub

