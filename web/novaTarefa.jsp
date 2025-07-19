<%@page import="Tarefas.TarefaDAO"%>
<%@page import="Tarefas.TarefaBean"%>
<%@page contentType="text/html" pageEncoding="windows-1252"%>

<!DOCTYPE html>
<html lang="pt-br">

<head>
    <meta charset="UTF-8">
    <title>Master-Detail de Tarefas</title>
    <link rel="stylesheet" href="./css/novaTarefa.css">
</head>

<body>
    <div class="container">
        <!-- MASTER -->
        <div class="master">
          <h2>Tarefa</h2>

          <form id="formTarefa" method="get" action="salvarTarefa.jsp">
            <input type="hidden" name="id_tarefas" id="id_tarefas" value="0" />
            <input type="text" name="titulo" id="titulo" placeholder="Título da tarefa" value="TITULO" required>
            <input type="text" name="responsavel" id="responsavel" placeholder="Responsável da tarefa" value="FLAVIO" required>

            <textarea  name="descricao" id="descricao" placeholder="Descrição da tarefa">Lorem ipsum dolor sit amet consectetur.</textarea>

            <div class="linha">
              <select name="prioridade" id="prioridade">
                <option value="baixa">Baixa</option>
                <option value="media">Média</option>
                <option value="alta">Alta</option>
              </select>

              <select name="status" id="status">
                <option value="pendente">Pendente</option>
                <option value="feito">Feito</option>
              </select>
            </div>

            <label for="data">Data prevista para conclusão</label>
            <input type="date" name="data" id="data" value="2025-07-18">

            <div class="botoes">
              <button type="submit" class="salvar">Salvar</button>
              <button type="reset" class="fechar"  onclick="window.location.href='index.jsp'">Cancelar</button>
            </div>
          </form>
        </div>


        <!-- DETAIL -->
        <div class="detail detail-inativa">
            <h2>Subtarefa</h2>
            <div class="task-section">

                <form action="salvarSubtarefa.jsp" method="post">
                    <input type="hidden" name="fk_tarefa" id="fk_tarefa" value="<%= request.getParameter("id_tarefas") %>">

                    <div class="campo">
                        <textarea name="descricao" id="descricaoDetail"
                            placeholder="Digite a descrição..." required></textarea>
                    </div>

                    <div class="campo">
                        <label for="dataDetail">Data prevista para conclusão</label>
                        <input type="date" name="data_conclusao" id="dataDetail" >
                    </div>

                    <button type="submit" class="salvar">Adicionar subtarefa</button>
                </form>

                
            </div>
            <h2>Lista de subtarefas</h2>


                <ul id="lista-tarefas">
                    <li>
                        <label>
                            <input type="checkbox">
                            Lorem ipsum dolor sit amet consectetur, adipisicing elit. 
                        </label><br>
                        <small>Data: 2025-07-18</small>
                    </li>
                    <li>
                        <label>
                            <input type="checkbox">
                            Lorem ipsum dolor sit amet consectetur, adipisicing elit. 
                        </label><br>
                        <small>Data: 2025-07-18</small>
                    </li>                    
                </ul>
        </div>
    </div>
    
    <script src="./js/script.js"></script>

        
    <%
       String id_tarefas = request.getParameter("id_tarefas");

       if (id_tarefas != null) {
           TarefaBean tarefa = new TarefaBean();
           tarefa.setId_tarefas(Integer.parseInt(id_tarefas));
           TarefaDAO tarefaDAO = new TarefaDAO();
           tarefaDAO.select(tarefa); %>
        
           <script>
                document.getElementById("id_tarefas").value = "<%= tarefa.getId_tarefas() %>";
                document.getElementById("titulo").value = "<%= tarefa.getTitulo() %>";
                document.getElementById("descricao").value = "<%= tarefa.getDescricao() %>";
                document.getElementById("responsavel").value = "<%= tarefa.getResponsavel() %>";
                document.getElementById("prioridade").value = "<%= tarefa.getPrioridade() %>";
                document.getElementById("status").value = "<%= tarefa.getStatus() %>";
                //document.getElementById("data").value = "<%= tarefa.getData_conclusao() %>";
                //document.getElementById("titulo-tarefa").innerHTML = "Nova Tarefa";
                //document.getElementById("btn-fechar").innerHTML = "Fechar";
                
                ativarDetalhe();
                
            </script> 
            
    <%  } %>

</body>

</html>