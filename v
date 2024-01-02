Sheets.Add(after:=Sheets(1)).Name = "NH Answer"
control As IRibbonControl
Sub GRABINFO()
Application.ScreenUpdating = False
Application.EnableEvents = False
Application.DisplayAlerts = False
Dim path As String, filename As String
Dim st As Worksheet, sheet2 As Worksheet
Dim i As Integer
Dim lr As Long, lc As Long, LastRow As Long, wn As String
wn = Workbooks(Workbooks.Count).Name
Dim wkb As Workbook
Set wkb = Workbooks(wn)

With Application.FileDialog(msoFileDialogFolderPicker)
        .Title = "Select a location containing the data file"
        .Show
        If .SelectedItems.Count = 0 Then
            Exit Sub
        Else
            path = .SelectedItems(1) & "\"
            
        End If
    End With


filename = Dir(path & "*.xlsx")
Do While filename <> ""
Workbooks.Open filename:=path & filename
Dim wb As Workbook
Set wb = Workbooks(filename)

If wb.Sheets.Count = wkb.Sheets.Count Then

For i = 1 To ThisWorkbook.Sheets.Count
Set st = wb.Worksheets(i)
Set sht = wkb.Worksheets(i)
lr = st.Cells(st.Rows.Count, "c").End(xlUp).Row
lc = st.Cells(1, st.Columns.Count).End(xlToLeft).Column
LastRow = sht.Cells(sht.Rows.Count, "c").End(xlUp).Row + 1
st.Cells(2, 1).Resize(lr, lc).Copy
sht.Activate
wkb.Worksheets(i).Cells(LastRow, 1).Select
ActiveSheet.Paste
Next i
Workbooks(filename).Close
filename = Dir()

ElseIf wb.Sheets.Count <> wkb.Sheets.Count Then
Workbooks(filename).Close
MsgBox "The tab# are not match to your target file. Please check the templete you are using."
Exit Do
Workbooks(filename).Close
End If
Loop



End Sub

Sub hashmap()
Dim GI_dic As Object
Set GI_dic = CreateObject("Scripting.Dictionary") 'Task Code: [ Group Name,  Need to Email to Third Party,   Employee Name(Main Contact), Contact Information ]
Dim temp_list As Object

For i = 5 To 11

    Set temp_list = CreateObject("Scripting.Dictionary")
    
    temp_list.Add "# of Tasks", Cells(i, "c").Value
    temp_list.Add "# of Errors", Cells(i, "d").Value
    temp_list.Add "# of Answers", Cells(i, "e").Value
    temp_list.Add "Error Ratio", Cells(i, "f").Value
    temp_list.Add "Accuracy Ratio", Cells(i, "g").Value
    
    GI_dic.Add Cells(i, "b").Value, temp_list

    Set temp_list = Nothing

Next i


Dim tgt As Object

For r = 5 To 11
    ee_Name = Cells(r, 2).Value
    Set tgt = GI_dic(ee_Name)
    
    '============ÅÐ¶ÏÌõ¼þ£¨±ÈÈçÖ»Òª95%ÒÔÉÏµÄ£©==============
    If tgt("Accuracy Ratio") > 0.95 Then
        
        k = tgt.keys
        v = tgt.Items
        
        For i = 0 To tgt.Count - 1
            Debug.Print ee_Name, k(i), v(i)
        Next i
    End If
    
    
Next r
End Sub




Sub CreateFolderIfNotExists(folderPath As String)
    Dim fso As Object
    Set fso = CreateObject("Scripting.FileSystemObject")
    
    ' Recursively create the folder if it does not exist
    If Not fso.FolderExists(folderPath) Then
        Call CreateParentFolder(fso.GetParentFolderName(folderPath))
        fso.CreateFolder folderPath
    End If
End Sub

Sub CreateParentFolder(parentFolderPath As String)
    Dim fso As Object
    Set fso = CreateObject("Scripting.FileSystemObject")
    
    ' Check if the parent folder exists
    If Not fso.FolderExists(parentFolderPath) Then
        ' Recursively create the parent folder
        CreateParentFolder fso.GetParentFolderName(parentFolderPath)
        ' Create the current parent folder
        fso.CreateFolder parentFolderPath
    End If
End Sub
Sub Test()
    Dim path As String
    path = "C:\Your\Path\Here"  ' Change to your desired path
    Call CreateFolderIfNotExists(path)
End Sub

