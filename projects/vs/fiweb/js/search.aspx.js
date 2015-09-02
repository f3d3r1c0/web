function popupmsg(msg)
{	
	$('#myPopupMsg').html(msg);
	document.getElementById('hclick').click();
}

function validate(f)
{
    try {

	    var aic = f.aic.value.trim().toUpperCase();

		if (aic.length == 0) 
            throw "Compilare il campo id foglietto";
		if (aic.length > 9) 
            throw "Codice non valido: troppe cifre";
		if (aic.length == 9 && (aic.charAt(0) != 'A'))
            throw "Codice non valido: carattere iniziale non valido";
		for (var i = 0; i < 8; i++) {
		    if ("0123456789".indexOf(aic.charAt(i)) < 0)
		        throw "Codice non valido: carattere in posizione " + (i + 1) + " non numerico";
		}

		return true;

	}
    catch (e) {

		popupmsg('Dati compilati non validi!<br/>' + e);
		return false;

	}

}