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
