var timeout = -1;        
var forced = false; 
var gsext = '.png'; 
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


function on_load(fid)
{
    var img_prefix = 'imgpage';

    $('img').each(function() {        
        var id = $(this).attr('id');        
        if (id.length <= img_prefix.length) return;    
        if (id.indexOf(img_prefix) != 0) return;    
        $(this).attr('src', 
                'pages/' + fid + 
                '?page=' + id.substr(img_prefix.length) + 
                (timeout > 0 ? '&timeout=' + timeout : '') + 
                (forced ? '&nocache=true' : '') + 
                '&gsext=' + gsext +
                '&gsopts=' + encodeURI(gsopts));
    });

}
