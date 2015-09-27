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
        if (vaic.charAt(0) == 'A') vaic = vaic.substr(1);
        if (vaic.charAt(0) == 'a') vaic = vaic.substr(1);

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


function reload()
{   

    $('#pdfembedded').attr('src', 'http://docs.google.com/gview?url=pages/' + doc.filename + '.pdf&embedded=true');
    
    for (var k = 0; k < 1; k ++) {                                                                            

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
    }
}


function chlang(lang)
{           
    var i;                        
    
    for (i = 0; i < 30; i++) {
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
    
    $(document)
      .ajaxStart(function () {
        $('#aic').hide();
        $('#loading').fadeIn();
      })
      .ajaxStop(function () {
        $('#loading').hide();
        $('#aic').show();
      });
      
    $('#aic').keypress (function (event) {
        if (event && event.which && event.which == 13) {
            dosearch();
        }
    });            

    if ($('#aic').val().trim().length > 0) {
        dosearch();
    }            

}           
