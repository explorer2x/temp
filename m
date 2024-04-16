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
