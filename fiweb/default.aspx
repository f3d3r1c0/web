<%@ Page Language="VB" EnableSessionState="false"%>
<%    
    Dim redirectPage = "dh1.aspx"
    
    Dim querystring As String = ""
    If Not Request.QueryString Is Nothing Then
        For Each q As String In Request.QueryString
            If q.ToLower() = "popup" Then
                '
                ' TODO: mascheramento popup?
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
