/*
 *  Reference Documentation
 *      @see http://demos.jquerymobile.com/1.0rc2/docs/api/events.html
 *      @see http://demos.jquerymobile.com/1.4.5/icons/       
 *
 */

var doc = null;           
var list = null;
var tbox = null;

function msgbox(mesg)
{           
    $('#popupDialogMessage').html(mesg);
    $('#popupDialog').popup('open');    
}

function dosearch(aic_)
{
    try {

        var vaic = null;

        if (aic_ && aic_.length > 0) {
            if (tbox) tbox.val(aic_);
            vaic = aic_;
        }
        else if (!tbox) {
            msgbox('Inserire il codice AIC');
            return;
        }
        else {
            vaic = tbox.val().trim();
        }

		if (!vaic || vaic.length == 0) throw 'Inserire il codice AIC';	

        if (vaic.charAt(0).toUpperCase() == 'A') vaic = vaic.substr(1);
        
        var aic = '';

        for (var i = 0; i < vaic.length; i++) {
            if ("0123456789".indexOf(vaic.charAt(i)) >= 0)
                aic += vaic.charAt(i);
            else if (" .-\r\n\t".indexOf(vaic.charAt(i)) < 0) 
                throw 'Il codice AIC inserito non &egrave; corretto.<br/>' 
                    + 'Deve contenere fino a un massimo di 9 caratteri numerici e '
                    + 'pu&ograve; avere come carattere iniziale la lettera A';               
        }

        while (aic.length < 9) {
            aic = '0' + aic; 
        }

        //  
        // visualizzo in caricamento ...
        //
        $('#caricamento').css('display', 'block');

        $('#page0file').load (function() {
            $('#caricamento').css('display', 'none');
        });

        //
        // effettuo la chiamata 
        //
        $.ajax({                    

            url: 'archive',
            dataType: 'json',
            data: '{ "aic": "' + aic + '" }',
            method: 'post',
                                
            success: function (data) {

                try {

                    if (!data && data.length <= 0) 
                        throw 'Codice AIC non valido o non trovato (2)';
                    
                    if (data[0].aicFS.length == 0) 
                        throw 'Il foglietto presente nella confezione &egrave; gi&agrave; aggiornato';
                    
                    doc = null;
                    list = data;

                    for (var i = 0; i < list.length; i ++) {    
                        if (list[i].isDefaultLanguage) {
                            doc = list[i];
                            break;
                        }
                    }   

                    if (!doc || doc == null) doc = list[0];

                    // azzero il campo ricerca                    
                    if (tbox) { tbox.val(''); }

                    reload();
                    
                    $.mobile.changePage('#page0', { 
                            allowSamePageTransition: true, 
                            transition: 'slidedown'
                        });


                }
                catch (e1) {                        

                    msgbox(e1);                            

                }

            },

            error: function (data) {   

                msgbox('Codice AIC non valido o non trovato');    
                
            }

        });

        // pulisco la lista di autocompletamento
        $('#autocomplete').html('');        

        /*
        $('#page0file').on("swiperight", function () {                      
            var pageid = $.mobile.activePage.attr('id');
        });

        $('#page0file').on("swipeleft", function () {         
        });                

        $('#page0file').on("swipeup", function () {          
        });

        $('#page0file').on("swipedown", function () {          
        });
        */

        $('#search').on("pageshow", function () {                         
            if (tbox) {
                tbox.focus();
            }
        });        

    }
    catch(e2) {
            
        msgbox(e2);            
        
    }         
}   

/*
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
*/

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
                "-dTextAlphaBits=1 " +
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
                $(this).css('display', 'none');
                $('#page' + (ic - 1) + 'footer').css('display', 'none');
            }
            else {
                $(this).attr('src', getpageurl (doc.filename, ic));
                $(this).css('display', 'block');                        
                $('#page' + (ic - 1) + 'footer').html('Pagina ' + ic + ' di ' + doc.pagesCount);
                $('#page' + (ic - 1) + 'footer').css('display', 'block');
            }                    
        }
    );          

    for (var k = 0; k < 1; k ++) {                                                                            

        $('#lang-it' + '-' + k).css('display', 'none');
        $('#lang-de' + '-' + k).css('display', 'none');
        $('#lang-en' + '-' + k).css('display', 'none');        
        $('#lang-fr' + '-' + k).css('display', 'none');
        
        for (var i = 0; i < list.length; i ++) {    
            var lang = list[i].language.toLowerCase();                                
            try {
                $('#lang-' + lang + '-' + k).css('display', 'block');
            }
            catch (e) {}
        }                           
    }    

}


function chlang(lang)
{           
    var i;  

    $('#caricamento').css('display', 'block');

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

function _onload(aic) {

    $("#autocomplete").on("filterablebeforefilter", function (e, data) {

        var $ul = $(this),
            $input = $(data.input),
            value = $input.val(),
            html = "";  

        tbox = $(data.input);

        $ul.html("");
        
        if (value && value.length > 2) {
            $ul.html("<li><div class='ui-loader'><span class='ui-icon ui-icon-loading'></span></div></li>");
            $ul.listview("refresh");
            $.ajax({
                url: "autocom",
                dataType: "jsonp",
                crossDomain: true,
                data: {
                    q: $input.val()
                }
            })
            .then(function (response) {
                $.each(response, function (i, val) {                    
                    html += '<li><a href="javascript:dosearch(\'' + val + '\');">' + val + '</a></li>';
                });
                $ul.html(html);
                $ul.listview("refresh");
                $ul.trigger("updatelayout");
            });
        }
    });
    
    $('#loading').height = $('#searchButton').height;

    $(document)
        .ajaxStart(function () {                   
            $('#searchButton').hide();
            $('#loading').fadeIn();
        })
        .ajaxStop(function () {                
            $('#loading').hide();
            $('#searchButton').fadeIn();    
        });

    //TODO: vedere se rifare lo stesso 

    //$('#popupAic').css('maxWidth', $(window.width));
    //$('#popupAic').css('maxHeight', $(window.height));
    //$('#popupDialog').css('maxWidth', $(window.width));
    //$('#popupDialog').css('maxHeight', $(window.height));
    
    // submit alla pressione di invio
    $(document).keydown(function(event){    
        var keycode = (event.keyCode ? event.keyCode : event.which);
        if(keycode == '13') {
            dosearch();
        }    
    });

    $(window).on( "orientationchange", function( event ) {
      //$( "#orientation" ).text( "This device is in " + event.orientation + " mode!" );
       $('img').each(
        function() {
            var id = $(this).attr('id');
            if (id == null) return;
            if (id.indexOf('page') < 0) return;                    
            if (id.indexOf('file') < 0) return;   
            $(this).css('width', $(window.width));            
        });              
    });
        
    //
    // TODO submit automatico se passato da query string
    //
    if (aic.length > 0) {
        dosearch(aic);  
        return;  
    }

    // previene il bookmark della pagina fatto su #page0
    if (window.location.href.indexOf('#page0') >= 0) {
        $('#searchclick').click();
    }

}           

