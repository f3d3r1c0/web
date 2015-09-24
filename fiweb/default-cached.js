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

function dosearch(numberOfPages)
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

                    //everything ok reset aic field ...
                    $('#aic').val('');

                    reload(numberOfPages);
                    
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

var swipe_off_flag = false;

function swipe_off()
{
    swipe_off_flag = true;
    setInterval("swipe_on()", 500);
}

function swipe_on() {
    swipe_off_flag = false;
}

function reload(numberOfPages)
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

    for (var k = 0; k < numberOfPages; k ++) {                                                                            

        $('#lang-it' + '-' + k).css('display', 'none');
        $('#lang-de' + '-' + k).css('display', 'none');
        $('#lang-en' + '-' + k).css('display', 'none');
        $('#lang-es' + '-' + k).css('display', 'none');
        $('#lang-fr' + '-' + k).css('display', 'none');
        
        for (var i = 0; i < list.length; i ++) {    
            var lang = list[i].language.toLowerCase();                                
            try {
                $('#lang-' + lang + '-' + k).css('display', 'block');
            }
            catch (e) {}
        }   

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
                        
        $('#page' + k + 'file').on("swiperight", function () {          
            if (swipe_off_flag) return;              
            var n = parseInt($.mobile.activePage.attr('id').substr(4));
            swipe_off();
            $.mobile.changePage('#page' + (n - 1), 
                { allowSamePageTransition: true, transition: 'slide', reverse: true });
        });

        $('#page' + k + 'file').on("swipeleft", function () {         
            if (swipe_off_flag) return;
            var n = parseInt($.mobile.activePage.attr('id').substr(4));                                        
            if (n >= doc.pagesCount - 1) return;
            swipe_off();
            $.mobile.changePage('#page' + (n + 1), 
                { allowSamePageTransition: true, transition: 'slide' }); 
        });                

        $('#page' + k + 'file').on("swipeup", function () {          
            if (swipe_off_flag) return;              
            var n = parseInt($.mobile.activePage.attr('id').substr(4));            
            swipe_off();
            alert('swipe up');
            $.mobile.changePage('#page' + (n - 1), 
                { allowSamePageTransition: true, transition: 'slideup'});
        });

        $('#page' + k + 'file').on("swipedown", function () {          
            if (swipe_off_flag) return;              
            var n = parseInt($.mobile.activePage.attr('id').substr(4));
            if (n >= doc.pagesCount - 1) return;
            swipe_off();
            $.mobile.changePage('#page' + (n - 1), 
                { allowSamePageTransition: true, transition: 'slidedown'});
        });

        /*
        $('#page' + k).on("pageshow", function () { 
            //
            // impostare qui eventuali azioni da esegure in fase di attivazione della pagina
            // attenzione: non usare il k come riferimento alla pagina, bensi la var n come segue 
            // var n = parseInt($.mobile.activePage.attr('id').substr(4));    
            //
        });
        */

    }

}


function chlang(lang, numberOfPages)
{           
    var i;                        
    
    for (i = 0; i < numberOfPages; i++) {
        $('#page' + i + 'file').attr('src', 'images/loading.gif');                
    }

    for (i = 0; i < list.length; i ++) {
        if (list[i].language.toLowerCase() == lang) {
            doc = list[i];                    
            break;
        }
    }

    reload(numberOfPages);                       

    if ($.mobile.activePage.attr('id') == 'page0') {
        $("html, body").animate({ scrollTop: 0 }, "slow");     
    }
    else {
        $.mobile.changePage('#page0', 
                { allowSamePageTransition: true, transition: 'slide', reverse: true });                
    }
    
}


function _onload(numberOfPages) {

    //
    // da vedere l'utilita di queste istruzioni
    //
    $.mobile.changePage("#other-page", { allowSamePageTransition: true });
    var $loading = $('#loading').hide();
    var $aic = $('#searchbutton').fadeIn();

    //
    // imposta il loader ajax 
    //
    $(document)
        .ajaxStart(function () {
            $aic.hide();
            $loading.fadeIn();
        })
        .ajaxStop(function () {
            $loading.hide();
            $aic.show();
        });
    

    //
    // abilita la ricerca tramite pressione del tasto invio
    //
    $('#aic').keypress (function (event) {
        if (event && event.which && event.which == 13) {
            dosearch();
        }
    });            

    //
    // reindirizza sul foglietto se aic viene popolato da aspx al caricamento 
    //
    if ($('#aic').val().trim().length > 0) {
        dosearch();
    }            
    
}
