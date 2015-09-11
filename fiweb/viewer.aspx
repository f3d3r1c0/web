<%@ Page Language="VB" EnableSessionState="False" %>
<%@ Import Namespace="System.Web.Configuration" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="webapp" %>
<%          
    Dim id As String = Nothing
    
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
        Response.Redirect("search.aspx?err=404&mesg=File%20F" + id +".pdf%20inesistente.", True)
        Return
    End If
    
    Dim languages = Tools.GetRequestParameter(Request, "languages")
    If Not languages Is Nothing Then
        If languages.ToString().EndsWith(",") Then
            languages = languages.ToString().Substring(0, languages.ToString().Length - 1)
        End If
    Else
        languages = "it" + id
    End If
    Dim currentLanguage = Tools.GetRequestParameter(Request, "language")
    Dim lkeys As String() = Nothing
    Dim lfiles As String() = Nothing
    Dim lopts As String() = Nothing
    If Not languages Is Nothing Then
        lkeys = languages.Split(",")
        ReDim lfiles(lkeys.Length - 1)
        ReDim lopts(lkeys.Length - 1)
        For i As Integer = 0 To lkeys.Length - 1
            lfiles(i) = lkeys(i).Substring(2)
            lkeys(i) = lkeys(i).Substring(0, 2)
            If currentLanguage = lkeys(i) Then
                lopts(i) = "selected=true"
            Else
                lopts(i) = ""
            End If
        Next
    End If
    
    
    Dim ldesc As Hashtable = New Hashtable()
    ldesc.Add("it", "Italiano")
    ldesc.Add("en", "English")
    ldesc.Add("es", "Espanol")
    ldesc.Add("de", "Deutsch")
    ldesc.Add("fr", "Français")
    
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

    <script type="text/javascript" src="js/viewer.aspx.js"></script>

    <meta name="apple-mobile-web-app-capable" content="yes" />
    
</head>

<!--
            @see https://demos.jquerymobile.com/1.2.0/docs/pages/page-transitions.html
            @see http://www.w3schools.com/jquerymobile/jquerymobile_transitions.asp    

            data-transition:
            ----------------
                fade
                flip
                flow
                pop
                slide
                slidefade
                slideup
                slidedown
                turn
                none
        -->   

<body style="margin: 0px;" oncontextmenu="return false" onload="on_load('<%= id %>', <%= pages %>)">

<%  For i As Integer = 1 To pages%>
     
    <div data-role="page" id="page<%= i %>">      

        <!--
            For jquery icons  
            @see http://demos.jquerymobile.com/1.4.5/icons/
            --> 

    <div data-role="footer" class="ui-footer ui-bar-a" role="contentinfo" style="position: fixed; width: 100%;">
        <div data-role="navbar" class="ui-navbar ui-mini" role="navigation">
            <ul class="ui-grid-b">

                <li class="ui-block-a">
                    <a 
                        <% If i > 1 Then %>
                        href="#page<%= i - 1%>" 
                        <% End If %>
                        data-transition="slide" 
                        data-direction="reverse" 
                        data-icon="arrow-l" 
                        data-corners="false" 
                        data-shadow="false" 
                        data-iconshadow="true" 
                        data-wrapperels="span" 
                        data-iconpos="top" 
                        data-theme="a" 
                        data-inline="true" 
                        class="ui-btn ui-btn-up-a ui-btn-inline ui-btn-icon-top">
                        <span class="ui-btn-inner">
                            <span class="ui-btn-text">Indietro
                            </span>
                            <span class="ui-icon ui-icon-grid ui-icon-shadow">&nbsp;</span>
                        </span>
                    </a>
                </li>

                <li class="ui-block-b">
                    <a href="javascript:document.location.href='search.aspx';" 
                        data-transition="slideup"                         
                        data-icon="search" 
                        data-corners="false" 
                        data-shadow="false" 
                        data-iconshadow="true" 
                        data-wrapperels="span" 
                        data-iconpos="top" 
                        data-theme="a" 
                        data-inline="true" 
                        class="ui-btn-active ui-btn ui-btn-inline ui-btn-icon-top ui-btn-up-a"> 
                        <span class="ui-btn-inner">
                            <span class="ui-btn-text">Nuova Ricerca
                            </span>
                            <span class="ui-icon ui-icon-grid ui-icon-shadow">&nbsp;</span>
                        </span>
                    </a>
                </li>

                <li class="ui-block-c">
                    <a 
                        <% If i < pages Then %>
                        href="#page<%= i + 1%>" 
                        <% End If %>
                        data-transition="slide"                         
                        data-icon="arrow-r" 
                        data-corners="false" 
                        data-shadow="false" 
                        data-iconshadow="true" 
                        data-wrapperels="span" 
                        data-iconpos="top" 
                        data-theme="a" 
                        data-inline="true" 
                        class="ui-btn ui-btn-inline ui-btn-icon-top ui-btn-up-a">
                        <span class="ui-btn-inner">
                            <span class="ui-btn-text">Avanti
                            </span>
                            <span class="ui-icon ui-icon-grid ui-icon-shadow">&nbsp;</span>
                        </span>
                    </a>
                </li>

            </ul>
        </div><!-- /navbar -->
    </div>

        <!--
        <div data-role="navbar" data-type="horizontal">
            <a class="ui-btn ui-shadow ui-corner-all ui-icon-arrow-u ui-btn-icon-top ui-btn-icon-notext"
                     href="javascript:document.location.href='search.aspx';"></a>                                
            <a class="ui-btn ui-shadow ui-corner-all ui-icon-arrow-l ui-btn-icon-left ui-btn-icon-notext"
                    href="#page<%= i - 1%>" 
                    data-transition="slide" 
                    data-direction="reverse"></a>                                        
            <a class="ui-btn ui-shadow ui-corner-all ui-icon-arrow-r ui-btn-icon-right ui-btn-icon-notext"
                    href="#page<%= i + 1%>" 
                    data-transition="slide"></a>                                    
            <select name="language" onchange="changeLanguage(this.value, '<%= languages %>')">
                <% For k As Integer = 0 To lkeys.Length - 1%>
                <option value="<%= lfiles(k) %>&language=<%= lkeys(k) %>" <%= lopts(k) %>>
                    <%= ldesc(lkeys(k))%>
                </option>
                <% Next%>                    
            </select>    
        </div>    
-->

        <!--

        <table data-role="header" data-type="horizontal" style"width: 100%;">
        <tr>
            <td>
            <a class="ui-btn ui-shadow ui-corner-all ui-icon-arrow-u ui-btn-icon-top ui-btn-icon-notext"
                     href="javascript:document.location.href='search.aspx';"></a>                                
            </td>
            <td>    
            <a class="ui-btn ui-shadow ui-corner-all ui-icon-arrow-l ui-btn-icon-left ui-btn-icon-notext"
                    href="#page<%= i - 1%>" 
                    data-transition="slide" 
                    data-direction="reverse"></a>                                        
            </td>
            <td>                
            <a class="ui-btn ui-shadow ui-corner-all ui-icon-arrow-r ui-btn-icon-right ui-btn-icon-notext"
                    href="#page<%= i + 1%>" 
                    data-transition="slide"></a>                                    
            </td>
            <td>                
            <select name="language" onchange="changeLanguage(this.value, '<%= languages %>')">
                <% For k As Integer = 0 To lkeys.Length - 1%>
                <option value="<%= lfiles(k) %>&language=<%= lkeys(k) %>" <%= lopts(k) %>>
                    <%= ldesc(lkeys(k))%>
                </option>
                <% Next%>                    
            </select>    
            </td>                       
        </tr>
        </table>    
        -->

      <div data-role="main" class="ui-content" style="vertical-align:middle;"> 
        <img style="width: 100%; border: 0px; border-top: 50px #ffffff solid;" src="#" id="imgpage<%= i %>" />
      </div>

      <div data-role="footer" style="text-align: right;">
        <!--
        <h1>pagina <%= i %> di <%= pages %></h1>        
    -->
        <select name="language" onchange="changeLanguage(this.value, '<%= languages %>')">
            <% For k As Integer = 0 To lkeys.Length - 1%>
            <option value="<%= lfiles(k) %>&language=<%= lkeys(k) %>" <%= lopts(k) %>>
                <%= ldesc(lkeys(k))%>
            </option>
            <% Next%>                    
        </select>    
      </div>

    </div>

<% next %>    

</body>

</html>
