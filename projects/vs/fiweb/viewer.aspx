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

<%--
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

            studio slide menu @see http://demos.jquerymobile.com/1.3.0-beta.1/docs/panels/

            html arrows:
            ------------
            left  &#8592;
            up    &#8593; 
            right &#8594; 
            down  &#8595; 

        --%>   

<body style="margin: 0px;" oncontextmenu="return false" onload="on_load('<%= id %>', <%= pages %>)">

<%  For i As Integer = 1 To pages%>
     
    <div data-role="page" id="page<%= i %>">
      
      <table style="position: fixed; top: 0px; left: 0px; width: 100%;" cellpadding="0" cellspacing="0">

        <tr data-role="header">    

            <td style="width: 50px;" data-role="header">                   
                <a href="javascript:document.location.href='search.aspx';">&#8962;</a>                    
            </td>      

            <td style="width: 50px;" data-role="header">              
            <% If i > 1 Then%> 
            <a href="#page<%= i - 1%>" data-transition="slide" data-direction="reverse">&#8656;</a>        
            <% End If%>
            </td>              
            
            <td style="width: 50px;" data-role="header">       
            <% If i < pages Then%> 
            <a href="#page<%= i + 1%>" data-transition="slide">&#8658;</a>        
            <% End If%>       
            </td>   
            
            <td align="right" valign="middle">       
            <% If Not lkeys Is Nothing Then%>
                <select name="language" onchange="changeLanguage(this.value, '<%= languages %>')">
                    <% For k As Integer = 0 To lkeys.Length - 1%>
                    <option value="<%= lfiles(k) %>&language=<%= lkeys(k) %>" <%= lopts(k) %>>
                        <%= ldesc(lkeys(k))%>
                    </option>
                    <% Next%>                    
                </select>    
            <% else %>
                Lingua unica
            <% end if  %>                               
            </td>       

        </tr>

      </table>

      <div data-role="main" class="ui-content"> 
        <img style="width: 100%; border: 0px;" src="#" id="imgpage<%= i %>" />
      </div>

      <div data-role="footer">
        <h1>pagina <%= i %> di <%= pages %></h1>        
      </div>

    </div>

<% next %>    

</body>

</html>
