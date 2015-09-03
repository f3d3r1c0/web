<%@ Page Language="VB" %>
<%     
    If Not Request.Params("id") Is Nothing Then
        id = Request.Params("id")
    ElseIf Not Request.QueryString("id") Is Nothing Then
        id = Request.QueryString("id")
    Else
        Response.Redirect("search.aspx", True)
    End If
%>
<!DOCTYPE html>
<html lang="en">

<head>

	<meta http-equiv="content-type" content="text/html; charset=UTF-8" />	
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" /> 
	<meta name="viewport" content="width=device-width, initial-scale=1.0" /> 
    
	<title>Visualizza foglietto illustrativo</title>

	<link rel="stylesheet" type="text/css" href="js/jquery.css" />
	<link rel="stylesheet" type="text/css" href="js/bookblock.css" />
	<link rel="stylesheet" type="text/css" href="js/custom.css" />

	<script type="text/javascript" src="js/ga.js"></script>
	<script type="text/javascript" src="js/modernizr.js"></script>	

	<meta name="apple-mobile-web-app-capable" content="yes" />

</head>

	<body oncontextmenu="return false;">

		<div id="container" class="container">	

			<div class="menu-panel">
                <img style="border: 0px; width: 240px" alt="Logo Aziendale" src="images/farmast.png" /><br />                
				<div>
					<a href="search.aspx">← Nuova Ricerca</a>                    
				</div>
                <h3>Indice Foglietto</h3>                
				<ul id="menu-toc" class="menu-toc">
                    <!-- menu contents here ... -->					
				</ul>
				
			</div>

			<div class="bb-custom-wrapper">

				<div style="perspective: 2000px;" id="bb-bookblock" class="bb-bookblock">

					<!-- contents here  ... -->

				</div> <!-- bb-bookblock -->
				
				<nav>
					<span style="display: none;" id="bb-nav-prev">&#9668;</span>
					<span id="bb-nav-next">&#9658;</span>
				</nav>

				<span id="tblcontents" class="menu-button">Table of Contents</span>

			</div>
				
		</div>	<!-- container -->

		<script type="text/javascript" src="js/jquery_003.js"></script>
		<script type="text/javascript" src="js/jquery_004.js"></script>
		<script type="text/javascript" src="js/jquery_002.js"></script>
		<script type="text/javascript" src="js/jquerypp.js"></script>
		<script type="text/javascript" src="js/jquery.js"></script>
        
        <script type="text/javascript">
            var _pageurl = 'pages/<%= id %>';
        </script>
        <script type="text/javascript" src="js/viewer.aspx.js"></script>                       
            
	</body>

</html>
