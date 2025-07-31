<%@page import="app.tarefas.TarefaBean"%>
<%@page import="java.util.List"%>
<%@page import="app.tarefas.TarefaDAO"%>
<%@page import="app.MinhaConexao"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <meta charset="UTF-8" />
        <title>To-Do List</title>
        <link rel="stylesheet" href="./css/index_claro.css">
        <link rel="stylesheet" href="./css/modal_claro.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    </head>
    <body>

        <header>
            <div class="container">
                <h1>To-Do List</h1>
                <button class="btn-add" onclick="window.location.href='novaTarefa.jsp?novoOuEditar=2'">Nova Tarefa</button>
                <!--<button class="btn-add" onclick="openModal()">Nova Tarefa</button>-->
            </div>
        </header>

        <div class="task-list">
            
            <%
                TarefaDAO tarefaDAO = new TarefaDAO();
                List<TarefaBean> tarefas = tarefaDAO.listarTarefas();

                if (tarefas == null || tarefas.isEmpty()) {
            %>
                <div class="container-imagem">
                    <img src="./img/personagem.png">
                <div>
            <%
                } else {
                
                    for (TarefaBean tarefa : tarefas) {

                        StringBuilder aux = new StringBuilder();

                        aux.append("<div class='task ");
                        aux.append(tarefa.getPrioridade());
                        aux.append("'> \n");

                        aux.append("  <div class='task-content'> \n");
                        aux.append("    <div class='task-title'>");
                        aux.append("        <a href='novaTarefa.jsp?id_tarefas="+ tarefa.getId_tarefas() +"&novoOuEditar=1' class='link-sem-estilo'> " + tarefa.getTitulo() + "</a>");
                        aux.append("    </div>");

                        aux.append("    <div class='task-meta'>");
                        aux.append("      <span><i class='fas fa-layer-group'></i> " + tarefa.getSubtarefas_counts() + " subtarefas</span>");
                        aux.append("      <span><i class='fas fa-calendar-day'></i> " + tarefa.getData_criacao() + "</span>");
                        aux.append("      <span><i class='fas fa-comments'></i> 0</span>");

                        aux.append("    </div>");

                        aux.append("    <span class='descricao'>");
                        aux.append(        tarefa.getDescricao());
                        aux.append("     </span>");
                        aux.append("   </div>");

                        aux.append("  <div class='task-actions'>");
                        aux.append("    <div>");
                        aux.append("      <label class='checkbox-container'>");
                        aux.append("        <div class='usuario_concluir'>");
                        aux.append("          <div class='assigned'><strong>");
                        aux.append(            tarefa.getResponsavel());
                        aux.append("           </strong></div>");
                        aux.append("          <input type='checkbox' name='concluir'/>");
                        aux.append("        </div>");
                        aux.append("      </label>");
                        aux.append("    </div>");

                        aux.append("<a href='#' class='deletar-link' onclick=\"openModalDeletar(");
                        aux.append(tarefa.getId_tarefas()); 
                        aux.append(", '");
                        aux.append(tarefa.getTitulo().replace("'", "\\'")); 
                        aux.append("', '");
                        aux.append(tarefa.getResponsavel().replace("'", "\\'"));
                        aux.append("', '");
                        aux.append(tarefa.getPrioridade().replace("'", "\\'"));
                        aux.append("', '");
                        aux.append(tarefa.getStatus().replace("'", "\\'"));
                        aux.append("'); return false;\"><i class='fas fa-trash'></i></a>");


                        aux.append("  </div>");

                        aux.append("</div>");

                        out.print(aux.toString());

                    }
                }
            %>

        </div>

        <!-- Modal -->
       
        <!-- Modal de Deletar -->
        <div class="modal-overlay" id="modalDeletar" style="display:none;">
            <div class="modal">
                <h2>Confirmar Exclusão</h2>
                <table class="tabela-confirmacao">
                    <tr>
                        <td><i class="fas fa-pen"></i> Título:</td>
                        <td id="tituloDeletar"></td>
                    </tr>
                    <tr>
                        <td><i class="fas fa-user"></i> Responsável:</td>
                        <td id="tituloResponsavel"></td>
                    </tr>
                    <tr>
                        <td><i class="fas fa-bolt"></i> Prioridade:</td>
                        <td id="tituloPrioridade"></td>
                    </tr>
                    <tr>
                        <td><i class="fas fa-thumbtack"></i> Status:</td>
                        <td id="tituloStatus"></td>
                    </tr>
                </table>
                <form id="formDeletar" method="post" action="deletarTarefa.jsp">
                    <input type="hidden" name="id_tarefas" id="id_tarefa_deletar" value="0" />
                    <div class="modal-buttons">
                        <button type="submit" class="btn-deletar-confirmar">Sim, deletar</button>
                        <button type="button" class="btn-cancelar" onclick="closeModalDeletar()">Cancelar</button>
                    </div>
                </form>
            </div>
        </div>
        
        <script src="./js/index.js"></script>  
        <script src="./js/Utilidades.js"></script>
    </body>
    
    <% tarefaDAO.fecharConexao(); %>
    
</html>