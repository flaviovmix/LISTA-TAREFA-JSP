function openModal() {
    // Limpa todos os campos do formulário
    document.getElementById("id_tarefas").value = "0";
    document.getElementById("titulo").value = "";
    document.getElementById("descricao").value = "";
    document.getElementById("responsavel").value = "";
    document.getElementById("prioridade").value = "baixa"; 
    document.getElementById("status").value = "pendente";
    document.getElementById("data").value = "";
    document.getElementById("titulo-tarefa").innerHTML = "Nova Tarefa";
    document.getElementById("btn-fechar").innerHTML = "Fechar";

    document.getElementById("modal").style.display = "flex";
}


function closeModal() {
    document.getElementById("modal").style.display = "none";
}

function closeModalDeletar() {
    document.getElementById("modalDeletar").style.display = "none";
}

function salvarTarefa() {
    const titulo = document.getElementById("titulo").value;
    const data = document.getElementById("data").value;
}

function openModalComEdicao(id, tipo) {
    const tarefa = tarefasMap[id];
    if (!tarefa) return;

    document.getElementById("id_tarefas").value = tarefa.id;
    document.getElementById("titulo").value = tarefa.titulo;
    document.getElementById("descricao").value = tarefa.descricao;
    document.getElementById("responsavel").value = tarefa.responsavel;
    document.getElementById("prioridade").value = tarefa.prioridade;
    document.getElementById("status").value = tarefa.status;
    document.getElementById("data").value = tarefa.data?.substring(0, 10); // só YYYY-MM-DD
    document.getElementById("titulo-tarefa").innerHTML = "Editar Tarefa";
    document.getElementById("btn-fechar").innerHTML = "Cancelar";
        
    document.getElementById("modal").style.display = "flex";
    
}

function openModalDeletar(id, titulo, responsavel, prioridade, status) {
    document.getElementById("id_tarefa_deletar").value = id;
    document.getElementById("tituloDeletar").innerHTML = `<strong>${titulo}</strong>`;
    document.getElementById("tituloResponsavel").textContent = responsavel;
    document.getElementById("tituloPrioridade").textContent = prioridade;
    document.getElementById("tituloStatus").textContent = status;
    
    document.getElementById("modalDeletar").style.display = "flex";
}


function ativarDetalhe() {
  var elemento = document.querySelector('.detail.detail-inativa');
  if (elemento) {
    elemento.classList.remove('detail-inativa');
  }
}

function ativarEdicao() {
    document.getElementById("campos-cadastro").classList.remove("opaco");
    document.getElementById("btn-cancelar").classList.remove("oculto");
    document.getElementById("btn-salvar").classList.remove("oculto");
    document.getElementById("btn-editar").classList.add("oculto");     
    document.getElementById("form-subtarefa").classList.add("opaco");
    document.getElementById("area-detail").classList.add("opaco");
}

function desartivarEdicao() {
    document.getElementById("campos-cadastro").classList.add("opaco");
    document.getElementById("btn-cancelar").classList.add("oculto");
    document.getElementById("btn-salvar").classList.add("oculto");
    document.getElementById("btn-editar").classList.remove("oculto");     
    document.getElementById("form-subtarefa").classList.remove("opaco");
    document.getElementById("area-detail").classList.remove("opaco");
    
}

function selecionarAddSubTarefa() {
    const campos = document.getElementById("campos-cadastro");
    const btnCancelar = document.getElementById("btn-cancelar");
    const btnSalvar = document.getElementById("btn-salvar");
    const btnEditar = document.getElementById("btn-editar");
    const input = document.getElementById("descricaoDetail");

    if (campos) campos.classList.remove("opaco");
    if (btnCancelar) btnCancelar.classList.remove("oculto");
    if (btnSalvar) btnSalvar.classList.remove("oculto");
    if (btnEditar) btnEditar.classList.add("oculto");
    if (input) input.focus();
}

window.onload = function () {
    selecionarAddSubTarefa();
};
function selecionarAddSubTarefa() {
    document.getElementById("descricaoDetail").focus();
}

document.getElementById("descricaoDetail").addEventListener("keydown", function (e) {
    if (e.key === "Enter" && !e.shiftKey) {
        e.preventDefault(); // Impede quebra de linha
        document.getElementById("form-subtarefa").submit(); // Envia o formulário
    }
});