function calcular() {
    var empresa = inpt_nomeEmpresa.value;
    var qtdLotes = Number(inpt_qtdLotesSoja.value);
    var valorLote = Number(inpt_valorLote.value);
    var mediaUmidade = Number(inpt_mediaUmidade.value);
    var qtdSensores = Number(inpt_qtdSensores.value);
    var maoDeObra = 5000; // custo da nossa mão de obra
    var custo = (qtdSensores * 100) + maoDeObra; // valor do custo da solução
    var total = custo * 1.30; // lucro de 30%
    var valorPerda = 0;
    var mensagemRisco = '';
    var mensagemSolucao = '';


    if (empresa == '' || qtdLotes == '' || valorLote == '' || mediaUmidade == '') {
        alert(`Digite em todos os campos!`);
    }
    else if (qtdLotes < 1 || valorLote < 1) {
        alert(`Digite valores coerentes!`);
    }
    else {
        valorPerda = qtdLotes * valorLote;

        mensagemRisco = `Terá um prejuízo de R$${valorPerda} se não tomar providências!`;

        mensagemSolucao = `Com a nossa solução, você tem um sistema de controle qualificado para cuidar do seu produto. 
Gastando apenas R$${total},00 você previne diariamente futuros estragos. Faça parte da AgroSmart!`

        if (mediaUmidade < 13) {
            alert(`${empresa} você possui risco de ter grãos trincados e quebrados.`)
            alert(mensagemRisco);
            alert(mensagemSolucao);
        }
        else if (mediaUmidade > 15) {
            alert(`${empresa} você possui risco de ter abrasão nos grãos`)
            alert(mensagemRisco);
            alert(mensagemSolucao);
        }
        else {
            alert(`Clima ideal para a colheita da soja!`);
            alert(`${empresa} ainda que a umidade esteja adequada ultimamente, você deve estar preparado para mudanças repentinas no clima, como acontece em diferentes estações do ano.`);
            alert(mensagemSolucao);
        }
        
    }
}