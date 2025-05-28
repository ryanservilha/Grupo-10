function calcular() {
    var empresa = inpt_nomeEmpresa.value;
    var qtdLotes = Number(inpt_qtdLotesSoja.value);
    var valorLote = Number(inpt_valorLote.value);
    var porcentagemPerda = Number(inpt_perda.value);
    var gasto = valorLote * qtdLotes;
    var valorPerda = gasto * (porcentagemPerda / 100);
    var msgSolucao = "<h2> Com a nossa solução você previne futuros danos na sua plantação e no seu bolso! <br> <br> <h1>Venha fazer parte da Agro Smart!</h1></h2>";

    if (empresa == '' || qtdLotes == '' || valorLote == '') {
        alert(`Digite em todos os campos!`);
    }
    else if (qtdLotes < 1 || valorLote < 1) {
        alert(`Digite valores coerentes!`);
    }
    else {
        if (porcentagemPerda > 0) {
            msg_simulador.innerHTML = `<h1> Olá <b style="color: #82da18">${empresa}!</b> </h1> <br>
            <h2> Você teve uma perda de <b style="color: red">R$${valorPerda}</b> na sua plantação! <br> </h2>`;
            msg_simulador.innerHTML += msgSolucao;
        }
        else {
            msg_simulador.innerHTML = `<h1> Olá <b style="color: #82da18">${empresa}!</b> </h1> <br>
            <h2> Por mais que ainda você não teve nenhuma perda na sua plantação, é necessário estar preparado para os momentos de dificuldade! <br> </h2>`;
            msg_simulador.innerHTML += msgSolucao;
        }

    }
}