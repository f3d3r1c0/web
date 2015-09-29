<%@ Page Language="VB" EnableSessionState="false"%>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="webapp" %>
<%    
	'Dim redirectPage = "dh0.aspx"	
    'Dim redirectPage = "dh1.aspx"
	'Dim redirectPage = "dh2.aspx"
	Dim redirectPage = "dh3.aspx"
    
    Dim masqPopup as Boolean = False
    Dim querystring As String = ""
    
    If Not Request.QueryString Is Nothing Then
        For Each q As String In Request.QueryString
            If q.ToLower() = "id" Then
                If Tools.RemoveTransactionId(Request.QueryString(q)) Then
                    masqPopup = True
                End If
            Else
                If querystring.Length = 0 Then
                    querystring = "?"
                Else
                    querystring = "&"
                End If
                querystring += q
                querystring += "="
                querystring += Request.QueryString(q)
            End If
        Next
    End If
    
    Dim url As String = redirectPage + querystring
    
    If masqPopup Then
        
        Dim html As String = ""
        Dim line As String
        Dim sr As StreamReader = New StreamReader(Path.GetFullPath(Context.Server.MapPath("./popup.html")))
        Do
            line = sr.ReadLine()
            If line Is Nothing Then Exit Do
            html += line.Replace("@url", url)
        Loop
        sr.Close()
        
        Response.ContentType = "text/html"
        Response.Write(html)
        Response.Flush()
        
        Return
        
    Else
        
        Response.Redirect(url, True)
        
    End If
    
    
    %>
