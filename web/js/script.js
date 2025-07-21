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

function removerOpaco() {
    const div = document.getElementById("campos-cadastro");
    if (div) {
        div.classList.remove("opaco");
    }
}
