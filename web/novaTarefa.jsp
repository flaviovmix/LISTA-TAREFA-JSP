<%@page import="Tarefas.SubtarefaBean"%>
<%@page import="java.util.List"%>
<%@page import="Tarefas.TarefaDAO"%>
<%@page import="Tarefas.TarefaBean"%>
<%@page contentType="text/html" pageEncoding="windows-1252"%>
<%
    Integer id = null;
    List<TarefaBean> tarefas = null;

    String idParam = request.getParameter("id_tarefas");

    if (idParam != null && !idParam.isEmpty()) {
        try {
            id = Integer.parseInt(idParam);
            TarefaDAO dao = new TarefaDAO();
            tarefas = dao.listarTarefasComSubtarefas(id);
        } catch (NumberFormatException e) {
            // Caso o parâmetro não seja um número válido
            id = null;
        }
    }

%>

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
                <button type="reset" class="voltar"  onclick="window.location.href = 'index.jsp'">Voltar</button>
                <h2>Tarefa</h2>

                <% if (tarefas != null && !tarefas.isEmpty()) {
                        for (TarefaBean tarefa : tarefas) {%>      

                <form id="formTarefa" method="get" action="salvarTarefa.jsp">
                    <input type="hidden" name="id_tarefas" id="id_tarefas" value="<%= tarefa.getId_tarefas()%>" />
                    <input type="text" name="titulo" id="titulo" placeholder="Título da tarefa" value="<%= tarefa.getTitulo()%>" required>
                    <input type="text" name="responsavel" id="responsavel" placeholder="Responsável da tarefa" value="<%= tarefa.getResponsavel()%>" required>

                    <textarea  name="descricao" id="descricao" placeholder="Descrição da tarefa"><%= tarefa.getDescricao()%></textarea>

                    <div class="linha">
                        <select name="prioridade" id="prioridade">
                            <option value="baixa">Baixa</option>
                            <option value="media">Média</option>
                            <option value="alta">Alta</option>
                        </select>

                        <select name="status" id="status">
                            <option value="pendente"><%= tarefa.getStatus()%></option>
                            <option value="feito">Feito</option>
                        </select>
                    </div>

                    <label for="data">Data prevista para conclusão</label>
                    <input type="date" name="data" id="data" value="2025-07-18">

                    <div class="botoes">
                        <button type="submit" class="salvar">Salvar</button>
                        <button type="reset" class="fechar"  onclick="window.location.href = 'index.jsp'">Cancelar</button>
                    </div>
                </form>

                <hr>

                <h2>Subtarefa</h2>
                <form action="salvarSubtarefa.jsp" method="post">
                    <input type="hidden" name="fk_tarefa" id="fk_tarefa" value="<%= id%>">

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


            <!-- DETAIL -->
            <div class="detail detail-inativa">

                <div class="task-section">




                </div>
                <h2>Lista de subtarefas</h2>


                <ul id="lista-tarefas">
                    <% for (SubtarefaBean sub : tarefa.getSubtarefas()) {%>
                    <li>
                        <label>
                            <input type="checkbox">
                            <%= sub.getDescricao()%>
                        </label><br>
                        <small>Data: 2025-07-18</small>
                    </li>   
                    <% } %>
                </ul>
                <% } %>
                <% } else { %>

                <form id="formTarefa" method="get" action="salvarTarefa.jsp">
                    <input type="hidden" name="id_tarefas" id="id_tarefas" value="0" />
                    <input type="text" name="titulo" id="titulo" placeholder="Título da tarefa" value="" required>
                    <input type="text" name="responsavel" id="responsavel" placeholder="Responsável da tarefa" value="" required>

                    <textarea  name="descricao" id="descricao" placeholder="Descrição da tarefa"></textarea>

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
                        <button type="reset" class="fechar"  onclick="window.location.href = 'index.jsp'">Cancelar</button>
                    </div>
                </form>

                <hr>

                <h2>Subtarefa</h2>
                <form action="salvarSubtarefa.jsp" method="post">
                    <input type="hidden" name="fk_tarefa" id="fk_tarefa" value="0">

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


            <!-- DETAIL -->
            <div class="detail detail-inativa">

                <div class="task-section">

                </div>
                <h2>Lista de subtarefas</h2>

                <ul id="lista-tarefas">
                </ul>

        <% }%>

            </div>
        </div>

        <script src="./js/script.js"></script>

        <script>
             ativarDetalhe();
        </script>




    </body>

</html>