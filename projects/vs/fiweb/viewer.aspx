﻿<%@ Page Language="VB" %>
<%    
    Dim id As String, base As String
    If Not Request.Params("id") Is Nothing Then
        id = Request.Params("id")
    ElseIf Not Request.QueryString("id") Is Nothing Then
        id = Request.QueryString("id")
    Else
        Response.RedirectPermanent("search.aspx", True)
    End If
    base = "js" 'webapp.FormatUtils.GetBaseUrl()
%>
<!DOCTYPE html>
<html lang="en">

<head>

	<meta http-equiv="content-type" content="text/html; charset=UTF-8" />	
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" /> 
	<meta name="viewport" content="width=device-width, initial-scale=1.0" /> 
    
	<title>Visualizza foglietto illustrativo</title>

	<link rel="stylesheet" type="text/css" href="<%= base %>/jquery.css" />
	<link rel="stylesheet" type="text/css" href="<%= base %>/bookblock.css" />
	<link rel="stylesheet" type="text/css" href="<%= base %>/custom.css" />

	<script type="text/javascript" src="<%= base %>/ga.js"></script>
	<script type="text/javascript" src="<%= base %>/modernizr.js"></script>	

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

		<script type="text/javascript" src="<%= base %>/jquery_003.js"></script>
		<script type="text/javascript" src="<%= base %>/jquery_004.js"></script>
		<script type="text/javascript" src="<%= base %>/jquery_002.js"></script>
		<script type="text/javascript" src="<%= base %>/jquerypp.js"></script>
		<script type="text/javascript" src="<%= base %>/jquery.js"></script>
        
        <script type="text/javascript">

            function htmlpage(page) {

                var html = '';

                var height = $(window).height();
                var width = $(window).width();

                if (page == 1) {
                    html += '<div style="display: block;" class="bb-item" id="item1">';
                    html += '	<div tabindex="0" class="content jspScrollable">';
                }
                else {
                    html += '<div class="bb-item" id="item' + (page) + '">';
                    html += '	<div class="content">';
                }

                html += '		<div class="scroller" style="'
									+ 'height: 2500px; width: 1700px;'
									+ 'background-size: ' + width + 'px;'
									+ 'background-repeat: no-repeat;'
									+ '" '
									+ 'id="viewpage' + (page) + '">';
                html += '		</div>';

                html += '	</div>';
                html += '</div>';

                return html;

            }

            function htmlmenu(page) {
                return (page == 1 ?
					'<li class="menu-toc-current"><a href="#item1">Pagina 1</a></li>' :
					'<li><a href="#item' + (page) + '">Pagina ' + (page) + '</a></li>');
            }

            //
            // AJAX document request
            //

            $.post('pages/<%= id %>', null, function (data) {
    
                var f_id = data.id;
                var pages = data.pages;

                var htpage = '';
                var htmenu = '';
                for (var i = 0; i < pages; i++) {
                    htpage += htmlpage((i + 1));
                    htmenu += htmlmenu((i + 1));
                }

                $('#bb-bookblock').html(htpage);
                $('#menu-toc').html(htmenu);

                for (var i = 0; i < pages; i++) {
                    $('#viewpage' + (i + 1)).css('background-image', 'url(' +
                        'pages/' + f_id + '?page=' + (i + 1) +
                        ')')
                }

                //
                // initialize document viewer definitions
                //

                var Page = (function () {

                    var $container = $('#container'),
		                $bookBlock = $('#bb-bookblock'),
		                $items = $bookBlock.children(),
		                itemsCount = $items.length,
		                current = 0,
		                bb = $('#bb-bookblock').bookblock({
		                    speed: 800,
		                    perspective: 2000,
		                    shadowSides: 0.8,
		                    shadowFlip: 0.4,
		                    onEndFlip: function (old, page, isLimit) {
		                        current = page;
		                        // update TOC current
		                        updateTOC();
		                        // updateNavigation
		                        updateNavigation(isLimit);
		                        // initialize jScrollPane on the content div for the new item
		                        setJSP('init');
		                        // destroy jScrollPane on the content div for the old item
		                        setJSP('destroy', old);
		                    }
		                }),
		                $navNext = $('#bb-nav-next'),
		                $navPrev = $('#bb-nav-prev').hide(),
		                $menuItems = $container.find('ul.menu-toc > li'),
		                $tblcontents = $('#tblcontents'),
		                transEndEventNames = {
		                    'WebkitTransition': 'webkitTransitionEnd',
		                    'MozTransition': 'transitionend',
		                    'OTransition': 'oTransitionEnd',
		                    'msTransition': 'MSTransitionEnd',
		                    'transition': 'transitionend'
		                },
		                transEndEventName = transEndEventNames[Modernizr.prefixed('transition')],
		                supportTransitions = Modernizr.csstransitions;

                    function init() {

                        // initialize jScrollPane on the content div of the first item
                        setJSP('init');
                        initEvents();

                    }

                    function initEvents() {

                        // add navigation events
                        $navNext.on('click', function () {
                            bb.next();
                            return false;
                        });

                        $navPrev.on('click', function () {
                            bb.prev();
                            return false;
                        });

                        // add swipe events
                        $items.on({
                            'swipeleft': function (event) {
                                if ($container.data('opened')) {
                                    return false;
                                }
                                bb.next();
                                return false;
                            },
                            'swiperight': function (event) {
                                if ($container.data('opened')) {
                                    return false;
                                }
                                bb.prev();
                                return false;
                            }
                        });

                        // show table of contents
                        $tblcontents.on('click', toggleTOC);

                        // click a menu item
                        $menuItems.on('click', function () {

                            var $el = $(this),
				                idx = $el.index(),
				                jump = function () {
				                    bb.jump(idx + 1);
				                };

                            current !== idx ? closeTOC(jump) : closeTOC();

                            return false;

                        });

                        // reinit jScrollPane on window resize
                        $(window).on('debouncedresize', function () {
                            // reinitialise jScrollPane on the content div
                            setJSP('reinit');
                        });

                    }

                    function setJSP(action, idx) {

                        var idx = idx === undefined ? current : idx,
			                $content = $items.eq(idx).children('div.content'),
			                apiJSP = $content.data('jsp');

                        if (action === 'init' && apiJSP === undefined) {
                            $content.jScrollPane({ verticalGutter: 0, hideFocus: true });
                        }
                        else if (action === 'reinit' && apiJSP !== undefined) {
                            apiJSP.reinitialise();
                        }
                        else if (action === 'destroy' && apiJSP !== undefined) {
                            apiJSP.destroy();
                        }

                    }

                    function updateTOC() {
                        $menuItems.removeClass('menu-toc-current').eq(current).addClass('menu-toc-current');
                    }

                    function updateNavigation(isLastPage) {

                        if (current === 0) {
                            $navNext.show();
                            $navPrev.hide();
                        }
                        else if (isLastPage) {
                            $navNext.hide();
                            $navPrev.show();
                        }
                        else {
                            $navNext.show();
                            $navPrev.show();
                        }

                    }

                    function toggleTOC() {
                        var opened = $container.data('opened');
                        opened ? closeTOC() : openTOC();
                    }

                    function openTOC() {
                        $navNext.hide();
                        $navPrev.hide();
                        $container.addClass('slideRight').data('opened', true);
                    }

                    function closeTOC(callback) {

                        updateNavigation(current === itemsCount - 1);
                        $container.removeClass('slideRight').data('opened', false);
                        if (callback) {
                            if (supportTransitions) {
                                $container.on(transEndEventName, function () {
                                    $(this).off(transEndEventName);
                                    callback.call();
                                });
                            }
                            else {
                                callback.call();
                            }
                        }
                        window.scrollTo(0, 0);

                    }

                    return { init: init };

                })();

                //
                // initialize document viewer 
                //

                $(function () {
                    Page.init();
                });

            });     /* end of AJAX document request callback */

            </script>                       
            
	</body>

</html>
