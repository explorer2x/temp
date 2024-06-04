'add below string to cells A1
{"menu": {
  "id": "file",
  "value": "File",
  "popup": {
    "menuitem": [
      {"value": "New", "onclick": "CreateNewDoc()"},
      {"value": "Open", "onclick": "OpenDoc()"},
      {"value": "Close", "onclick": "CloseDoc()"}
    ]
  }
}}


Sub get_your_json_value()
your_json_string = [a1].Value

'--------------------use below script if excel is 32-bit and remove blow one---------------------------------------
Dim ScriptControl As New MSScriptControl.ScriptControl
ScriptControl.Language = "JavaScript"
ScriptControl.AddCode ("var query = " & your_json_string)

'--------------------use below script if excel is 64-bit and remove above one---------------------------------------
'Dim ScriptControl As Object
'Set ScriptControl = CreateObjectx86("MSScriptControl.ScriptControl")
 
 
ScriptControl.Language = "JavaScript"
ScriptControl.AddCode ("var query = " & your_json_string)

'------get item from json--------
var_id = ScriptControl.Eval("query.menu.id")
var_value = ScriptControl.Eval("query.menu.value")
'------loop all menuitem--------

For i = 0 To ScriptControl.Eval("query.menu.popup.menuitem.length") - 1
    i_value = ScriptControl.Eval("query.menu.popup.menuitem[" & i & "].value")
    i_onclick = ScriptControl.Eval("query.menu.popup.menuitem[" & i & "].onclick")
    Debug.Print i_value, i_onclick
Next i

Debug.Print var_id, var_value
Set ScriptControl = Nothing

End Sub

'--------------------add below script if excel is 64-bit---------------------------------------

Function CreateObjectx86(Optional sProgID, Optional bClose = False)
Static oWnd As Object
Dim bRunning As Boolean
#If Win64 Then
bRunning = InStr(TypeName(oWnd), "HTMLWindow") > 0
If bClose Then
If bRunning Then oWnd.Close
Exit Function
End If
If Not bRunning Then
Set oWnd = CreateWindow()
oWnd.execScript "Function CreateObjectx86(sProgID): Set CreateObjectx86 = CreateObject(sProgID): End Function", "VBScript"
End If
Set CreateObjectx86 = oWnd.CreateObjectx86(sProgID)
#Else
Set CreateObjectx86 = CreateObject("MSScriptControl.ScriptControl")
#End If
End Function
Function CreateWindow()
Dim sSignature, oShellWnd, oProc
On Error Resume Next
 
    sSignature = Left(CreateObject("Scriptlet.TypeLib").GUID, 38)
    CreateObject("WScript.Shell").Run "%systemroot%\syswow64\mshta.exe about:""about:<head><script>moveTo(-32000,-32000);document.title='x86Host'</script><hta:application showintaskbar=no /><object id='shell' classid='clsid:8856F961-340A-11D0-A96B-00C04FD705A2'><param name=RegisterAsBrowser value=1></object><script>shell.putproperty('" & sSignature & "',document.parentWindow);</script></head>""", 0, False
Do
 
For Each oShellWnd In CreateObject("Shell.Application").Windows
    Set CreateWindow = oShellWnd.GetProperty(sSignature)
    If Err.Number = 0 Then Exit Function
        Err.Clear
    Next
Loop
End Function





        


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




Sub MoveAndRenameFile(sourceFilePath As String, destinationFilePath As String)
    Dim fso As Object
    Set fso = CreateObject("Scripting.FileSystemObject")

    ' Check if the source file exists
    If fso.FileExists(sourceFilePath) Then
        ' Move and rename the file
        fso.MoveFile Source:=sourceFilePath, Destination:=destinationFilePath
    Else
        MsgBox "File not found: " & sourceFilePath
    End If
End Sub




Function ExtractDetailsFromFileName(fileName As String) As Variant
    Dim regex As Object
    Dim matches As Object
    Dim accountName As String
    Dim date1 As String
    Dim date2 As String

    Set regex = CreateObject("VBScript.RegExp")
    
    ' Regex pattern to match your file name formats
    ' Pattern explanation:
    ' - Captures any characters between "for " and the first hyphen as account name
    ' - Then captures two date patterns in d-m-yyyy format
    regex.Pattern = "Report for (.+?)- (\d{1,2}-\d{1,2}-\d{4})-(\d{1,2}-\d{1,2}-\d{4})"
    regex.Global = False
    regex.IgnoreCase = True

    Set matches = regex.Execute(fileName)

    If matches.Count = 1 Then
        accountName = matches(0).SubMatches(0)
        date1 = matches(0).SubMatches(1)
        date2 = matches(0).SubMatches(2)
        ExtractDetailsFromFileName = Array(accountName, date1, date2)
    Else
        ExtractDetailsFromFileName = Array("Invalid format", "", "")
    End If
End Function
Sub TestExtractDetails()
    Dim fileName As String
    Dim details As Variant

    ' Example file name
    fileName = "Birthday Report for XYZ Corp- 1-2-2023- 3-4-2023.xlsx"

    ' Call the function
    details = ExtractDetailsFromFileName(fileName)

    ' Print the results
    If details(0) <> "Invalid format" Then
        Debug.Print "Account Name: " & details(0)
        Debug.Print "Date 1: " & details(1)
        Debug.Print "Date 2: " & details(2)
    Else
        Debug.Print "File name format not recognized."
    End If
End Sub










Sub ListAllFiles()
    Dim FileSystem As Object
    Set FileSystem = CreateObject("Scripting.FileSystemObject")
    Dim startFolder As String
    Dim sheet As Worksheet
    Dim rowNumber As Long

    startFolder = "C:\Users\mason_wang\Desktop\JN\test pool\projects\Done - Project - AHDCC Mockup"

    Set sheet = ThisWorkbook.Sheets("Sheet1")
    rowNumber = 1
    

    ListFilesRecursive startFolder, FileSystem, sheet, rowNumber
End Sub

Private Sub ListFilesRecursive(ByVal folderPath As String, ByRef FileSystem As Object, ByRef sheet As Worksheet, ByRef rowNumber As Long)
    Dim folder As Object
    Set folder = FileSystem.GetFolder(folderPath)
    Dim subFolder As Object
    Dim file As Object
    

    For Each file In folder.Files
        sheet.Cells(rowNumber, 1).Value = file.Path
        sheet.Cells(rowNumber, 2).Value = file.Name
        rowNumber = rowNumber + 1
    Next file

    For Each subFolder In folder.SubFolders
        ListFilesRecursive subFolder.Path, FileSystem, sheet, rowNumber
    Next subFolder
End Sub

