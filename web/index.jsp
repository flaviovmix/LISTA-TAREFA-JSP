<%@page import="java.util.Locale"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="app.Utilidades" %>
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

                    SimpleDateFormat sdf = new SimpleDateFormat("EEEE, dd MMM - yyyy", new Locale("pt", "BR"));

                    for (TarefaBean tarefa : tarefas) {

                        StringBuilder aux = new StringBuilder();

                        aux.append("<div class='task ")
                           .append(Utilidades.arrumarCaractereHtmlJs(tarefa.getPrioridade()))
                           .append("'>\n");

                        aux.append("  <div class='task-content'>\n");

                        aux.append("    <div class='task-title'>");
                        aux.append("      <a href='novaTarefa.jsp?id_tarefas=")
                           .append(         tarefa.getId_tarefas())
                           .append(         "&novoOuEditar=1' class='link-sem-estilo'>")
                           .append(         Utilidades.arrumarCaractereHtmlJs(tarefa.getTitulo()))
                           .append("      </a>");
                        aux.append("    </div>\n");

                        aux.append("    <div class='task-meta'>");
                        aux.append("      <span><i class='fas fa-layer-group'></i> ")
                           .append(         tarefa.getSubtarefas_counts())
                           .append("        subtarefas</span>");
                        aux.append("      <span><i class='fas fa-calendar-day'></i> ")
                           .append(         Utilidades.arrumarCaractereHtmlJs(sdf.format(tarefa.getData_criacao())))
                           .append("      </span>");
                        aux.append("      <span><i class='fas fa-comments'></i> 0</span>");
                        aux.append("    </div>\n");

                        aux.append("    <span class='descricao'>");
                        aux.append(         Utilidades.arrumarCaractereHtmlJs(tarefa.getDescricao()));
                        aux.append("    </span>\n");

                        aux.append("  </div>\n");

                        aux.append("  <div class='task-actions'>\n");

                        aux.append("    <div>");
                        aux.append("      <label class='checkbox-container'>");
                        aux.append("        <div class='usuario_concluir'>");
                        aux.append("          <div class='assigned'><strong>")
                           .append(             Utilidades.arrumarCaractereHtmlJs(tarefa.getResponsavel()))
                           .append("            </strong></div>");
                        aux.append("          <input type='checkbox' name='concluir'/>");
                        aux.append("        </div>");
                        aux.append("      </label>");
                        aux.append("    </div>\n");

                        // Botão de deletar
                        aux.append("    <a href='#' class='deletar-link' onclick=\"openModalDeletar(")
                           .append(tarefa.getId_tarefas()).append(", '")
                           .append(Utilidades.arrumarCaractereHtmlJs(tarefa.getTitulo())).append("', '")
                           .append(Utilidades.arrumarCaractereHtmlJs(tarefa.getResponsavel())).append("', '")
                           .append(Utilidades.arrumarCaractereHtmlJs(tarefa.getPrioridade())).append("', '")
                           .append(Utilidades.arrumarCaractereHtmlJs(tarefa.getStatus())).append("'); return false;\">")
                           .append("<i class='fas fa-trash'></i>")
                           .append("</a>\n");

                        aux.append("  </div>\n");
                        aux.append("</div>\n");

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