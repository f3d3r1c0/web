<%@ Page Language="VB" EnableSessionState="False" %>
<%   
    Dim pdf As String = Nothing
    
    If Not Request.Params("id") Is Nothing Then
        pdf = Request.Params("id")
    ElseIf Not Request.QueryString("id") Is Nothing Then
        pdf = Request.QueryString("id")
    End If
    
    If pdf Is Nothing Then
        Response.Redirect("search.aspx", True)
    End If
    
    If pdf.ToLower().EndsWith(".pdf") Then
        pdf = pdf.Substring(0, pdf.Length - 4)
    End If
    
    While pdf.Length < 7
        pdf = "0" + pdf
    End While
    
    If Not pdf.ToUpper().StartsWith("F") Then pdf = "F" + pdf
    
%>
<!DOCTYPE html>
<html lang="en">

<head>
	
	<title>Visualizza foglietto illustrativo</title>

<meta charset="utf-8" />

	<!-- Set the viewport width to device width for mobile -->
	<meta name="viewport" content="width=device-width" />

	<title>ViewerJS Examples</title>

	<!-- Included CSS Files -->
	<link rel="stylesheet" href="js/pdfviewer/app.css">
	<link rel="stylesheet" href="js/pdfviewer/local.css">
	<link rel="stylesheet" href="js/pdfviewer/special.css">  
	<script src="js/pdfviewer/modernizr.foundation.js"></script>
	<script defer="defer" type="text/javascript" src="js/pdfviewer/sie.js"></script>
    <script src="js/jquery-1.11.3.min.js"></script>

	<!-- IE Fix for HTML5 Tags -->
	    <!--[if lt IE 9]>
		    <script
                src="/javascripts/html5.js"></script>
	        <![endif]-->

    <script type="text/javascript">

        function resize() {
            $("#pdf").css("width", $(window).width());
            $("#pdf").css("height", $(window).height());
        }

    </script>

</head>

	<body oncontextmenu="return false;" onload="resize()">

		<iframe id="pdf" src = "/docs/<%= pdf %>" 
                style="border: 0px;" 
                allowfullscreen webkitallowfullscreen></iframe>              
            
	</body>

</html>
