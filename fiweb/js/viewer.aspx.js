function on_load(fid)
{    
    var timeout = -1;        
    var forced = false; 
    var gsext = 'png'; 
    var img_prefix = 'imgpage';

    $('img').each(function() {        
        var id = $(this).attr('id');        
        if (id.length <= img_prefix.length) return;    
        if (id.indexOf(img_prefix) != 0) return;    
        var gsopts = "-sDEVICE=pngalpha " +         
                "-dFirstPage=" + id.substr(img_prefix.length) + " " +
                "-dLastPage=" + id.substr(img_prefix.length) + " " +
                "-dMaxBitmap=500000000 " +                    
                        "-dAlignToPixels=0 " +
                        "-dGridFitTT=0 " +          
                        "-dTextAlphaBits=4 " +
                        "-dGraphicsAlphaBits=4 " +
                        "-r120x120";
        $(this).attr('src', 
                'pages/' + fid + 
                '?page=' + id.substr(img_prefix.length) + 
                (timeout > 0 ? '&timeout=' + timeout : '') + 
                (forced ? '&nocache=true' : '') + 
                '&gsext=' + gsext +
                '&gsopts=' + encodeURI(gsopts));
    });
}

function changeLanguage(doc, languages)
{
    document.location.href = 'viewer.aspx?id=' + doc + "&languages=" + languages;
}