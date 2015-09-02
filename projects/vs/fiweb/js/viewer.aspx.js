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

$.post(_pageurl, null, function (data) {

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

