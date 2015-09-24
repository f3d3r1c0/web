<%@ Page Language="VB" EnableSessionState="false"%>
<%    
    Dim redirectPage = "default-cached.aspx"
    
    Dim querystring As String = ""
    If Not Request.QueryString Is Nothing Then
        For Each q As String In Request.QueryString
            If q.ToLower() = "popup" Then
                '
                ' TODO: gestire eventualmente mascheramento popup
                '
                '                
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
    
    Response.Redirect(redirectPage + querystring, True)
    
    %>
