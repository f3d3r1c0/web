function popupmsg(msg)
{	
	$('#myPopupMsg').html(msg);
	document.getElementById('hclick').click();
}

function validate(f)
{
	var emsg1 = "Codice AIC inserito non valido<br />"
		+ "<ol>" 
		+ "<li>Il codice deve essere un numero di max 9 cifre</li>"
		+ "<li>Eventuali zeri iniziali possono essere omessi</li>"
		+ "</ol>"; 

    try {

    	if (f.idf) return true;
    	if (f.pdf) return true;
		
	    var aic = f.aic.value.trim().toUpperCase();

		if (aic.length == 0) 
            throw "Inserire il codice AIC";
		if (aic.length > 10) 
            throw emsg1
		if (aic.length == 10 && (aic.charAt(0) != 'A'))
            throw emsg1;
		for (var i = 0; i < 9; i++) {
		    if ("0123456789".indexOf(aic.charAt(i)) < 0)
		        throw emsg1;
		}

		return true;

	}
    catch (e) {

		popupmsg(e);
		return false;

	}

}