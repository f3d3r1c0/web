<%@ Page Language="VB" %>
<%@ Import Namespace="System.Web.Configuration" %>
<%@ Import Namespace="webapp" %>
<%
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

        function popupmsg(msg)
        {   
            $('#myPopupMsg').html(msg);
            document.getElementById('hclick').click();
        }

        function validate(f)
        {
            
            var emsg1 = "Codice AIC inserito non valido<br />"
                + "<ol>" 
                + "<li>Il codice deve essere un numero di max 9 cifre</li>"
                + "<li>Eventuali zeri iniziali possono essere omessi</li>"
                + "</ol>"; 

            try {

                if (f.idf) return true;
                if (f.pdf) return true;                
                
                var aic = f.aic.value.trim().toUpperCase();                
                
                if (aic.length == 0) 
                    throw "Inserire il codice AIC";
                
                if (aic.indexOf('TEST') == 0) return true;

                if (aic.length > 10) 
                    throw emsg1
                
                if (aic.length == 10 && (aic.charAt(0) != 'A'))
                    throw emsg1;
                
                for (var i = 0; i < 9; i++) {
                    if ("0123456789".indexOf(aic.charAt(i)) < 0)
                        throw emsg1;
                }

                return true;
            }
            catch (e) {
                popupmsg(e);
                return false;
            }
        }
        
    </script>
    
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <link rel="apple-touch-icon-precomposed" href="images/farmadati-apple-icon.png" />
    <script type="text/javascript" src="js/bookmark_bubble.js"></script>
    <script type="text/javascript" src="js/bookmark_bubble_msg_it.js"></script>
    <script type="text/javascript" src="js/bookmark_bubble_activator.js"></script>

    <link rel="icon" type="image/png" href="images/farmadati-apple-icon.png">
    
</head>

<body oncontextmenu="return true;">

<center>

    <table>
        <tr>
            <td><img alt="Farmastampati Logo" src="images/farmast.png"/></td>
        </tr>
        <tr>
            <td align="center" valign="middle"><i>Visualizza il foglietto illustrativo</i></td>
        </tr>
    </table>	

    <form id="form" data-ajax="false" method="POST" action="document" onsubmit="return validate(this)">
    	<table>
            <tr>
				<td align="center">Inserisci il Codice AIC</td>			
			</tr>
			<tr>
                <!--
				<td><input name="aic" type="text" maxlength="10" size="10"/></td>
                -->
                <td><input name="aic" type="text" size="10"/></td>
			</tr>	    	            
            <tr>                
				<td><input id="submit" type="submit" value="cerca" /></td>
			</tr>
		</table>    
	</form> 
    
	<br />

	<div id="showaic">
		<i style="font-size: small;">
            Il codice AIC lo trovi nella<br/>
            scatola del medicinale
            <br />
            <a href="#aicPopup" data-rel="popup" data-transition="flip">            
                Clicca qui per vedere un esempio
            </a>
        </i>

        <br />
        		
        <div data-role="popup" id="aicPopup" class="ui-content">
            <img style="border: 0px; width: 400px;" alt="Codiice Agenzia Italiana del Farmaco" src="images/aicsample.jpg"/>
        </div>

	</div>

    <div data-role="main" class="ui-content">
	    <a id="hclick" href="#myPopup" data-rel="popup" class="ui-btn ui-btn-inline ui-corner-all" style="display: none"></a>
	    <div data-role="popup" id="myPopup" class="ui-content" style="color: #AA1221; font-weight:bolder; text-align: center;">
	      <a href="#" data-rel="back" class="ui-btn ui-corner-all ui-shadow ui-btn ui-icon-delete ui-btn-icon-notext ui-btn-right">Close</a>
	      <p id="myPopupMsg"></p>      
	    </div>
	</div>
    
</center>

<script type="text/javascript" src="js/bookmark_bubble_activator.js"></script>

<%
    If Not Request.QueryString("mesg") Is Nothing Then
        %>
    <script type="text/javascript">
        popupmsg('<%= Request.QueryString("mesg") %>');
    </script>        
<%
    End If
    
    %>

</body>

</html>
