
function cadastrarConta() {
    var razaoSocial = inpt_razaoSocial.value;
    var cnpj = inpt_cnpj.value;
    var emailCadastrado = inpt_emailCadastrado.value;
    var telefone = inpt_telefone.value;
    var senhaCadastrada = inpt_senhaCadastrada.value;
    var confirmeSenha = inpt_confirmeSenha.value;

    if (razaoSocial == "" || cnpj == "" || emailCadastrado == "" || telefone == "" || senhaCadastrada == "" || confirmeSenha == "") {
        alert('Preencha todos os campos!')
    }
    else if (cnpj.length != 14) {
        alert('CNPJ inválido!')
    }
    else if (telefone.length != 11) {
        alert('Telefone inválido')
    }
    else if (confirmeSenha != senhaCadastrada) {
        alert('Erro na confirmação de senha')
    }
    else {
        for (var i = 0; i <= emailCadastrado.length; i++) {
            if (emailCadastrado[i] == '@') {
                alert('Cadastro Realizado Com Sucesso!')
                break;
            }
            else if (i == emailCadastrado.length) {
                alert('Email Inválido!')
            }
        }
    }
}


function entrarConta() {
    var emailUsuario = inpt_emailUsuario.value;
    var senhaUsuario = inpt_senhaUsuario.value;

    if (emailUsuario == "soja@gmail.com" && senhaUsuario == "123") {
        alert('Login Realizado com Sucesso!');
        window.location.href = "dashboard.html";
    }

    else {
        alert('Você ainda não possui uma conta');
    }

}