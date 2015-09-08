
$.post(_pageurl, null, function (data) {
    var html = '';
    var f_id = data.id;
    var pages = data.pages;
    for (var i = 0; i < pages; i++) {
        var page = i;
        page ++;
        /* timeout in ms for the backend ghostscript process */
        var timeout = -1;
        /* force to recreate the page (don't use cached pages in image files */
        var forced = false; 
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
        var url = 'pages/' + f_id + 
                '?page=' + page + 
                (timeout > 0 ? '&timeout=' + timeout : '') + 
                (forced ? '&nocache=true' : '') + 
                '&gsopts=' + encodeURI(gsopts);
        html += '<img src="';
        html += url;
        html += '" style="border: 0px; width: 100%; overflow: scroll;"></img>';
        html += '<br />';
    }
    $('#container').html(html);
}

);
    