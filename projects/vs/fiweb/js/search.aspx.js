function popupmsg(msg)
{	
	$('#myPopupMsg').html(msg);
	document.getElementById('hclick').click();
}

function validate(f)
{

    try {

    	if (f.idf) return true;
    	if (f.pdf) return true;
		
	    var aic = f.aic.value.trim().toUpperCase();

		if (aic.length == 0) 
            throw "Compilare il campo testo del codice aic";
		if (aic.length > 10) 
            throw "Codice non valido: troppe cifre";
		if (aic.length == 10 && (aic.charAt(0) != 'A'))
            throw "Codice non valido: carattere iniziale non valido";
		for (var i = 0; i < 9; i++) {
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