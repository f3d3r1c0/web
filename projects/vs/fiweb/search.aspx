<%@ Page Language="VB" %>
<%    
    Dim base As String
    base = "js" 'webapp.FormatUtils.GetBaseUrl()
%>
<!DOCTYPE html>
<html lang="en">	
<head>
	<meta name="viewport" content="width=device-width, initial-scale=1"/>
	<title>Ricerca Foglietto Illustrativo</title>
    
	<link rel="stylesheet" href="<%= base %>/jquery.mobile-1.4.5.min.css"/>
    <script type="text/javascript" src="<%= base %>/jquery-1.11.3.min.js"></script>
	<script type="text/javascript" src="<%= base %>/jquery.mobile-1.4.5.min.js"></script>
    
	<script type="text/javascript">

		function popupmsg(msg)
		{	
			$('#myPopupMsg').html(msg);
			document.getElementById('hclick').click();
        }

		function validate(f)
		{
		    try {

			    var aic = f.aic.value.trim().toUpperCase();

				if (aic.length == 0) 
                    throw "Compilare il campo id foglietto";
				if (aic.length > 9) 
                    throw "Codice non valido: troppe cifre";
				if (aic.length == 9 && (aic.charAt(0) != 'A'))
                    throw "Codice non valido: carattere iniziale non valido";
				for (var i = 0; i < 8; i++) {
				    if ("0123456789".indexOf(aic.charAt(i)) < 0)
				        throw "Codice non valido: carattere in posizione " + (i + 1) + " non numerico";
				}

				return true;

			}
            catch (e) {

				popupmsg('Dati compilati non validi!<br/>' + e);
				return false;

			}

        }

	</script>

	<% If LCase(Request.QueryString("pupup")) = "true" Then%>
    <link rel="apple-touch-icon-precomposed" href="images/farmadati-apple-icon.png" />
    <script type="text/javascript" src="<%= base %>/bookmark_bubble.js"></script>
    <% End If%>

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

    <% If LCase(Request.QueryString("pupup")) = "true" Then %>

	<script type="text/javascript">

	    window.addEventListener('load', function () {
	        window.setTimeout(function () {
	            var bubble = new google.bookmarkbubble.Bubble();

	            var parameter = 'bmb=1';

	            bubble.hasHashParameter = function () {
	                return window.location.hash.indexOf(parameter) != -1;
	            };

	            bubble.setHashParameter = function () {
	                if (!this.hasHashParameter()) {
	                    window.location.hash += parameter;
	                }
	            };

	            bubble.getViewportHeight = function () {
	                window.console.log('Example of how to override getViewportHeight.');
	                return window.innerHeight;
	            };

	            bubble.getViewportScrollY = function () {
	                window.console.log('Example of how to override getViewportScrollY.');
	                return window.pageYOffset;
	            };

	            bubble.registerScrollHandler = function (handler) {
	                window.console.log('Example of how to override registerScrollHandler.');
	                window.addEventListener('scroll', handler, false);
	            };

	            bubble.deregisterScrollHandler = function (handler) {
	                window.console.log('Example of how to override deregisterScrollHandler.');
	                window.removeEventListener('scroll', handler, false);
	            };

	            bubble.showIfAllowed();
	        }, 1000);
	    }, false);

	</script>

    <% End If  %>

</body>

</html>
