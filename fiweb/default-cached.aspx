<%@ Page Language="VB" EnableSessionState="false"%>
<%@ Import Namespace="webapp" %>
<%
    Dim PAGESER as Integer = 30
    Dim aic As String = ""
    If Not Request.QueryString("aic") Is Nothing Then
        aic = Request.QueryString("aic").Trim().ToUpper()
    End If
    %>
<!DOCTYPE html>
<html lang="en">
<head>  

    <!-- Android -->
    <!--
    <meta name="viewport" 
        content="initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,width=device-width,height=device-height,target-densitydpi=device-dpi,user-scalable=yes" />
        -->
    <!-- IOS -->
    <meta name="viewport" 
        content="initial-scale=1.0,width=device-width,user-scalable=0" />
    <!-- Chrome -->
    <!--
    <meta name="viewport" 
        content="initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,width=device-width,user-scalable=no" />
        -->
    <!-- Unknown device -->
    <!--
    <meta name="viewport" 
        content="width=device-width, initial-scale=1"/>
        -->
    
    <title>Foglietto Illustrativo</title>
    
    <!-- JQuery Libraries -->
    <link rel="stylesheet" href="js/jquery.mobile-1.4.5.min.css"/>
    <script type="text/javascript" src="js/jquery-1.11.3.min.js"></script>
    <script type="text/javascript" src="js/jquery.mobile-1.4.5.min.js"></script>

    <!-- Icons -->
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <link rel="apple-touch-icon-precomposed" href="images/farmadati-apple-icon.png" />
    <link rel="icon" type="image/png" href="images/farmadati-apple-icon.png">    
    
    <!-- Smartphone Splash Screen -->
    <!-- iPhone -->
    <link href="images/apple-touch-startup-image-320x460.png"
          media="(device-width: 320px) and (device-height: 480px) and (-webkit-device-pixel-ratio: 1)"
          rel="apple-touch-startup-image">  
    <!-- iPhone (Retina) -->
    <!--
    <link href="apple-touch-startup-image-640x920.png"
          media="(device-width: 320px) and (device-height: 480px)
             and (-webkit-device-pixel-ratio: 2)"
          rel="apple-touch-startup-image">
          -->
    <!-- iPhone 5 -->
    <!--
    <link href="apple-touch-startup-image-640x1096.png"
          media="(device-width: 320px) and (device-height: 568px) and (-webkit-device-pixel-ratio: 2)"
          rel="apple-touch-startup-image">
          -->
    <!-- iPad (portrait) -->
    <!-- 
    <link href="apple-touch-startup-image-768x1004.png"
          media="(device-width: 768px) and (device-height: 1024px) and (orientation: portrait) and (-webkit-device-pixel-ratio: 1)"
          rel="apple-touch-startup-image">
          -->
    <!-- iPad (landscape) -->
    <!-- 
    <link href="apple-touch-startup-image-748x1024.png"
          media="(device-width: 768px) and (device-height: 1024px) and (orientation: landscape) and (-webkit-device-pixel-ratio: 1)"
          rel="apple-touch-startup-image">
          -->
    <!-- iPad (Retina, portrait) -->
    <!-- 
    <link href="apple-touch-startup-image-1536x2008.png"
          media="(device-width: 768px) and (device-height: 1024px) and (orientation: portrait) and (-webkit-device-pixel-ratio: 2)"
          rel="apple-touch-startup-image">
          -->
    <!-- iPad (Retina, landscape) -->
    <!-- 
    <link href="apple-touch-startup-image-1496x2048.png"
          media="(device-width: 768px) and (device-height: 1024px) and (orientation: landscape) and (-webkit-device-pixel-ratio: 2)"
          rel="apple-touch-startup-image">
          -->

    <!-- Page Scripting -->
    <script type="text/javascript">

        /*
         *  Reference Documentation
         *      @see http://demos.jquerymobile.com/1.0rc2/docs/api/events.html
         *      @see http://demos.jquerymobile.com/1.4.5/icons/       
         *
         */

        var list = null;
        var doc = null;           

        function msgbox(mesg)
        {           
            $('#error').html(mesg);
            $('#displayerror').click();
        }
        
        function dosearch()
        {
            try {

                var vaic = $('#aic').val().trim();

                if (vaic.length == 0) throw 'Inserire il codice AIC';
                if (vaic.charAt(0) == 'A') vaic = aic.substr(1);
                if (vaic.charAt(0) == 'a') vaic = aic.substr(1);

                var aic = '';

                for (var i = 0; i < vaic.length; i++) {
                    if ("0123456789".indexOf(vaic.charAt(i)) >= 0)
                        aic += vaic.charAt(i);
                    else if (" .-\r\n\t".indexOf(vaic.charAt(i)) < 0) 
                        throw 'Codice AIC non valido<br />' 
                            + 'Deve contenere solo caratteri numerici,<br />'
                            + 'puo\' avere come carattere iniziale \'A\'';               
                }

                while (aic.length < 9) {
                    aic = '0' + aic; 
                }

                $.ajax({                    

                    url: 'archive',
                    dataType: 'json',
                    data: '{ "aic": "' + aic + '" }',
                    method: 'post',
                                        
                    success: function (data) {

                        try {

                            if (!data && data.length <= 0) 
                                throw 'codice AIC ' + aic + ' non trovato';
                                                        
                            doc = null;
                            list = data;
    
                            for (var i = 0; i < list.length; i ++) {    
                                if (list[i].isDefaultLanguage) {
                                    doc = list[i];
                                    break;
                                }
                            }   

                            if (!doc || doc == null) doc = list[0];

                            reload();
                            
                            $("#success").click();

                        }
                        catch (e1) {                        

                            msgbox(e1);                            

                        }

                        $("#loading-popup").hide();

                    },

                    error: function (data) {   

                        $("#loading-popup").hide();
                        msgbox('Codice AIC non trovato');    
                        
                    }

                });
            }
            catch(e2) {
            
                $("#loading-popup").hide();
                msgbox(e2);    
                
            }         
        }   
        
        function getpageurl(filename, page)
        {            
            var timeout = -1;
            var nocache = false; 
            var gsext = 'png';            
            var gsopts = 
                "-sDEVICE=pngalpha " +         
                "-dFirstPage=" + page + " " +
                "-dLastPage=" + page + " " +
                "-dMaxBitmap=500000000 " +                    
                        "-dAlignToPixels=0 " +
                        "-dGridFitTT=0 " +          
                        "-dTextAlphaBits=4 " +
                        "-dGraphicsAlphaBits=4 " +
                        "-r120x120"; 
            return 'pages/' + filename + '?page=' + page +
                    (timeout > 0 ? '&timeout=' + timeout : '') + 
                    (nocache ? '&nocache=true' : '') + 
                    '&gsext=' + gsext +
                    '&gsopts=' + encodeURI(gsopts);                                
        }

        function reload()
        {            
            var ic = 0;

            $('img').each(
                function () {
                    var id = $(this).attr('id');
                    if (id == null) return;
                    if (id.indexOf('page') < 0) return;                    
                    if (id.indexOf('file') < 0) return;                    
                    ic ++;
                    if (ic > doc.pagesCount) {
                        $(this).attr('src', 'images/loading.gif');                        
                        $('#page' + (ic - 1) + 'footer').html('loading ...');
                    }
                    else {
                        $(this).attr('src', getpageurl (doc.filename, ic));
                        $('#page' + (ic - 1) + 'footer').html('Pagina ' + ic + ' di ' + doc.pagesCount);
                    }                    
                }
            );             


            var htmlopts = ''; 
            for (var i = 0; i < list.length; i ++) {    
                var lang = list[i].language.toLowerCase();                                
                if (lang == 'it') desc = 'Italiano';
                else if (lang == 'de') desc = 'Deutsch';
                else if (lang == 'en') desc = 'English';
                else if (lang == 'fr') desc = 'Francais';
                else if (lang == 'es') desc = 'Espanol';
                else continue;
                if (htmlopts.indexOf('value="' + lang + '"') >= 0) continue;
                htmlopts += '<option value="';
                htmlopts += lang;
                htmlopts += '"';
                htmlopts += (list.length == 1 || list[i].language == doc.language ? ' selected="true">' : '>');
                htmlopts += desc;
                htmlopts += '</option>';
            }   

            for (var k = 0; k < <%= PAGESER %>; k ++) {                                                                            

                $('#page' + k + 'select').html(htmlopts); 

                var ik = -1;  

                $('#page' + k + ' a').each (function() {
                    switch (ik) {
                        case -1:
                            $(this).attr('href', '#page' + (k + ik));       
                            break;                                         
                        case 1:
                            $(this).attr('href', (k < doc.pagesCount - 1 ? 
                                    '#page' + (k + ik) : 
                                    '#'));
                            break;
                    }                    
                    ik ++;                    
                });

                $('#page' + k).on("swiperight", function () {                        
                    var n = parseInt($.mobile.activePage.attr('id').substr(4));
                    $.mobile.changePage('#page' + (n - 1), 
                        { allowSamePageTransition: true, transition: 'slide', reverse: true });
                });

                $('#page' + k).on("swipeleft", function () {         
                    var n = parseInt($.mobile.activePage.attr('id').substr(4));                    
                    if (n >= doc.pagesCount - 1) return;
                    $.mobile.changePage('#page' + (n + 1), 
                        { allowSamePageTransition: true, transition: 'slide' }); 
                });

                //$('#page' + k).on("pageshow", function () {                    
                //
                //});

            }

        }

                
        function selchange(selobj)
        {           
            var i;            
            var lang = selobj.value;            
            
            for (i = 0; i < <%= PAGESER %>; i++) {
                $('#page' + i + 'file').attr('src', 'images/loading.gif');                
            }

            for (i = 0; i < list.length; i ++) {
                if (list[i].language.toLowerCase() == lang) {
                    doc = list[i];                    
                    break;
                }
            }

            reload();                       

            if ($.mobile.activePage.attr('id') == 'page0') {
                $("html, body").animate({ scrollTop: 0 }, "slow");     
            }
            else {
                $.mobile.changePage('#page0', 
                        { allowSamePageTransition: true, transition: 'slide', reverse: true });                
            }
            
        }

        function _onload() {

            $.mobile.changePage("#other-page", { allowSamePageTransition: true });

            var $loading = $('#loading').hide();
            var $aic = $('#searchbutton').fadeIn();

            $(document)
              .ajaxStart(function () {
                $aic.hide();
                $loading.fadeIn(1000);
              })
              .ajaxStop(function () {
                $loading.hide();
                $aic.show();
              });

            if ($('#aic').val().trim().length > 0) {
                dosearch();
            }
            
        }

    </script>

</head>

<body oncontextmenu="return true;" onload="_onload()">

<center>
    
<div id="search" data-role="page">

    <div data-role="main" class="ui-content" style="max-width: 400px;"> 
        
        <div data-role="main" class="ui-content" data-mini="true">

            <!-- logo -->
            <img alt="Farmastampati Logo" src="images/farmast.png"/><br />
            <span style="font-style: italic;">Visualizza il foglietto illustrativo</span><br /><br />

            <!-- aic text box -->
            <span style="font-weight: bolder;">Inserisci il Codice AIC</span>                   
            
            <div class="ui-content"> 
                <input name="aic" id="aic" type="text" size="10" value="<%= aic %>">
            </div>

            <!-- popup, available positions: window, origin, #id -->
            <a id="displayerror" style="display: none;" 
                    href="#popupCloseRight" data-rel="popup" class="ui-btn ui-corner-all ui-shadow ui-btn-inline" 
		            data-position-to="window" 
		            data-transition="flip">...</a>
                <div data-role="popup" id="popupCloseRight" class="ui-content"
                        style="max-width:280px; border: 3px #aa1111 solid; color: darkRed;">
                    <a href="#" data-rel="back" 
                            class="ui-btn ui-corner-all ui-shadow ui-btn-a ui-icon-delete ui-btn-icon-notext ui-btn-right"
			                style="background-color: #dd4231;">Close</a>
	                <p id="error">...</p>
            </div>
            <!-- end popup -->
            
            <!-- search button click -->
            <a id="success" style="display: none" href="#page0" data-transition="slideup"></a>          
            <div id="searchbutton" class="ui-content"> 
                <a href="javascript: dosearch();" 
                    class="ui-btn ui-corner-all ui-shadow ui-btn-middle">Cerca</a><br />
            </div>
            <div id="loading" class="ui-content">
                <img alt="loading" src="js/images/ajax-loader.gif"/>
            </div>

            <!-- Aic help instructions  -->
            <span>                      
                <a href="#aicPopup" data-rel="popup" data-transition="flip" data-position-to="window" 
                        class="ui-btn ui-corner-all ui-shadow ui-btn-middle">            
                        Non trovi il codice AIC del medicinale<br/>
                    <span style="font-size: 36px; font-weight: bolder;">?</span>
                </a>
            </span>            
            <div data-role="popup" id="aicPopup" class="ui-content">
            <a href="#" data-rel="back" 
                        class="ui-btn ui-corner-all ui-shadow ui-btn-a ui-icon-delete ui-btn-icon-notext ui-btn-right"
                        style="background-color: #dd4231;">Close</a>
            <span style="font-weight: smaller;">
                Il codice AIC viene riportato di<br/>
                solito su un lato della scatola<br/>
                come nella figura di esempio
            </span>
            <img style="border: 0px; width: 400px;" 
                    alt="Codiice Agenzia Italiana del Farmaco" 
                    src="images/aicsample.jpg"/>
            </div>

        </div>
            
    </div>

</div>

<!-- END SEARCH FORM -->

<!-- BEGIN VISUALIZER -->

<%
    For i As Integer = 0 To PAGESER
    %>

<div data-role="page" id="page<%= i %>">      
        
    <div data-role="footer" class="ui-footer ui-bar-a" role="contentinfo" style="position: fixed; width: 100%;">
        <div data-role="navbar" class="ui-navbar ui-mini" role="navigation">
            <ul class="ui-grid-b">

                <li class="ui-block-a">
                    <a href="#page<%= i - 1 %>"
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
                    <a href="#search" 
                        data-transition="slidedown"                         
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
                    <a href="#page<%= i + 1 %>"
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
               
    </div><!-- /footer -->

    <div data-role="main" class="ui-content" style="vertical-align:middle;"> 
        <img style="width: 100%; border: 0px; border-top: 50px #ffffff solid;" src="images/loading.gif" id="page<%= i %>file" />
    </div>

    <div data-role="footer" style="text-align: right;">
        <h1 id="page<%= i %>footer">Pagina ? di ?</h1>        
        <select id="page<%= i %>select" 
            <% If i > 0 Then %>
            style="display: none;"
            <% End If %>
            onchange="selchange(this)">
        </select>
    </div>

</div>

<%        
    Next
 %>

<!-- END VISUALIZER -->

</center>

</body>

</html>
