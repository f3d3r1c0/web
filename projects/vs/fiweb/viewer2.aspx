<%@ Page Language="VB" EnableSessionState="False" %>
<%@ Import Namespace="webapp" %>
<%   
    Dim id As String
    
    If Not Request.Params("id") Is Nothing Then
        id = Request.Params("id")
    ElseIf Not Request.QueryString("id") Is Nothing Then
        id = Request.QueryString("id")
    Else
        Response.Redirect("search.aspx", True)
    End If
    
    Dim otype As Integer = Tools.GetBrowserId(Request)
    
%>
<!DOCTYPE html>
<html lang="en">

<head>

	<% If otype = 1 Then %>
    <!-- Android -->
    <meta name="viewport" content="initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,width=device-width,height=device-height,target-densitydpi=device-dpi,user-scalable=yes" />
    <!-- IOS -->
    <% ElseIf otype = 2 Then %>
    <meta name="viewport" content="initial-scale=1.0,width=device-width,user-scalable=0" />
    <!-- Chrome -->
    <% ElseIf otype = 3 Then%>
    <meta name="viewport" content="initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,width=device-width,user-scalable=no" />
    <% Else %>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <% End If %>

	<title>Foglietto Illustrativo</title>

	<link rel="stylesheet" href="js/jquery.mobile-1.4.5.min.css"/>
    <script type="text/javascript" src="js/jquery-1.11.3.min.js"></script>
	<script type="text/javascript" src="js/jquery.mobile-1.4.5.min.js"></script>
    <script type="text/javascript">
        var _pageurl = 'pages/<%= id %>';
    </script>

    <script type="text/javascript" src="js/viewer2.aspx.js"></script>

    <meta name="apple-mobile-web-app-capable" content="yes" />
    
</head>

<body oncontextmenu="return false">

    <div id="container" class="container">                      
    </div>
        
</body>

</html>
