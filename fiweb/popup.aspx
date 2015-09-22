<%@ Page Language="VB"  EnableSessionState="false" %>
<%  
    Dim querystring As String = ""
    If Not Request.QueryString Is Nothing Then
        For Each q As String In Request.QueryString
            If querystring.Length = 0 Then
                querystring = "?"
            Else
                querystring = "&"
            End If
            querystring += q
            querystring += "="
            querystring += Request.QueryString(q)
        Next
    End If
    %>
<!DOCTYPE html>
<html lang="en">
	<meta charset="utf-8">
    <meta name="viewport" content="width=device-width,minimum-scale=1.0,maximum-scale=1.0" />
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <link rel="apple-touch-icon-precomposed" href="images/farmadati-apple-icon.png" />	
	<title>Foglietto Illustrativo</title>
	<link rel="stylesheet" href="js/jquery.mobile.min.css" />
    <script type="text/javascript" src="js/jquery.min.js"></script>
	<script type="text/javascript" src="js/bookmark_bubble.js"></script>
    <script type="text/javascript" src="js/bookmark_bubble_msg_it.js"></script>
    <script type="text/javascript" src="js/bookmark_bubble_activator.js"></script>
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <link rel="apple-touch-icon-precomposed" href="images/farmadati-apple-icon.png" />
    <link rel="icon" type="image/png" href="images/farmadati-apple-icon.png">
	<script>
      page_popup_bubble = "#index";
      //page_popup_bubble = "default.aspx";

    //$("#TB_iframeContent")[0];
    //iframe.contentWindow.focus()

    </script>		
	<script type="text/javascript" src="js/jquery.mobile.min.js"></script>	
<head></head>
<body>
<body oncontextmenu="return true;">
<center>
	<div data-role="page" id="index">
		<iframe style="overflow: hidden; border: 0px; width: 100%; height: 1000px;" src="default-cached.aspx<%= querystring %>"></iframe>
	</div>	
</center>
</body>
</html>
