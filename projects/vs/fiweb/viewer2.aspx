<%@ Page Language="VB" EnableSessionState="False" %>
<%@ Import Namespace="System.Web.Configuration" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="webapp" %>
<%   
    
    'see http://www.w3schools.com/jquerymobile/jquerymobile_transitions.asp
    
    'Const transition As String = "fade"
    'Const transition As String = "flip"
    'Const transition As String = "flow"
    'Const transition As String = "pop"
    'Const transition As String = "slide"
    Const transition As String = "slidefade"
    'Const transition As String = "slideup"
    'Const transition As String = "slidedown"
    'Const transition As String = "turn"
    'Const transition As String = "none"
        
    Dim id As String
    
    If Not Request.Params("id") Is Nothing Then
        id = Request.Params("id")
    ElseIf Not Request.QueryString("id") Is Nothing Then
        id = Request.QueryString("id")
    Else
        Response.Redirect("search.aspx", True)
    End If
    
    Dim otype As Integer = Tools.GetBrowserId(Request)
    
    Dim utils As ITextUtils = New ITextUtils()
    Dim documentRoot As String = WebConfigurationManager.AppSettings("documentRoot")
    If Not Path.IsPathRooted(documentRoot) Then
        documentRoot = Path.GetFullPath(Context.Server.MapPath("..") + documentRoot)
    End If
    If Not documentRoot.EndsWith("\") Then
        documentRoot += "\"
    End If
    
    id = id.ToLower().Replace("f", "").Replace(".pdf", "")
    While id.Length < 7
        id = "0" + id
    End While
    
    Dim pdf As String = documentRoot
    pdf += "F"
    pdf += id
    pdf += ".pdf"
                    
    Dim pages As Integer = utils.GetNumberOfPdfPages(pdf)
    
    If pages <= 0 Then
        Response.Redirect("search.aspx?err=404", True)
        Return
    End If
    
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

    <script type="text/javascript" src="js/viewer2.aspx.js"></script>

    <meta name="apple-mobile-web-app-capable" content="yes" />
    
</head>

<body style="margin: 0px;" oncontextmenu="return false" onload="on_load('<%= id %>', <%= pages %>)">

<%  For i As Integer = 1 To pages%>

    <div data-role="page" id="page<%= i %>">

      <div style="position: absolute; right: 0px; top: 0px;" data-role="header">
        <i>pagina <%= i %></i>
      </div>

      <div data-role="main" class="ui-content">        

        <div style="position: absolute; left: 0px; top: 0px;" href="#page<%= i - 1%>">
            <% If i > 1 Then%> 
            <a  href="#page<%= i - 1%>" data-transition="<%= transition %>">indietro</a>
            <% End If%>
            <% If i < pages Then%> 
            <a  href="#page<%= i + 1%>" data-transition="<%= transition %>">avanti</a>
            <% End If%>
        </div>

        <img style="width: 100%; border: 0px" src="#" id="imgpage<%= i %>" />

      </div>

      <!--
      <div data-role="footer">
        <h1>Footer Text</h1>
      </div>
      -->

    </div> 

<% next %>

</body>

</html>
