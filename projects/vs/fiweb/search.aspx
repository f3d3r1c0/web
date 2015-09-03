<%@ Page Language="VB" %>
<% 
    Dim scpath As String
    
    scpath = System.Web.Configuration.WebConfigurationManager.AppSettings("scriptsPath")
    If scpath Is Nothing Then scpath = "js/"
    If Not scpath.EndsWith("/") Then scpath += "/"

%>
<!DOCTYPE html>
<html lang="en">	
<head>
	<meta name="viewport" content="width=device-width, initial-scale=1"/>
	<title>Ricerca Foglietto Illustrativo</title>    
	<link rel="stylesheet" href="<%= scpath %>jquery.mobile-1.4.5.min.css"/>
    <script type="text/javascript" src="<%= scpath %>jquery-1.11.3.min.js"></script>
	<script type="text/javascript" src="<%= scpath %>jquery.mobile-1.4.5.min.js"></script>
    <script type="text/javascript" src="<%= scpath %>search.aspx.js"></script>	
    <link rel="apple-touch-icon-precomposed" href="images/farmadati-apple-icon.png" />
    <script type="text/javascript" src="<%= scpath %>bookmark_bubble.js"></script>
    
</head>

<body oncontextmenu="return false;">

<center>

    <table>
        <tr>
            <td style="background: url('images/bg.png');"><img alt="Farmastampati Logo" src="images/farmast.png"/></td>
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
				<td><input name="aic" type="text" maxsize="10" size="10"/></td>
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
            scatola del medicinale come nella figura di esempio:
        </i>
        <br />
		<img style="border: 0px; width: 400px;" alt="Codiice Agenzia Italiana del Farmaco" src="images/aicsample.jpg"/>
	</div>

    <div data-role="main" class="ui-content">
	    <a id="hclick" href="#myPopup" data-rel="popup" class="ui-btn ui-btn-inline ui-corner-all" style="display: none"></a>
	    <div data-role="popup" id="myPopup" class="ui-content" style="color: #AA1221; font-weight:bolder; text-align: center;">
	      <a href="#" data-rel="back" class="ui-btn ui-corner-all ui-shadow ui-btn ui-icon-delete ui-btn-icon-notext ui-btn-right">Close</a>
	      <p id="myPopupMsg"></p>      
	    </div>
	</div>
    
</center>

<script type="text/javascript" src="<%= scpath %>bookmark_bubble_activator.js"></script>

</body>

</html>
