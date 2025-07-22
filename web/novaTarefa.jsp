<%@page import="Tarefas.SubtarefaBean"%>
<%@page import="java.util.List"%>
<%@page import="Tarefas.TarefaDAO"%>
<%@page import="Tarefas.TarefaBean"%>
<%@page contentType="text/html" pageEncoding="windows-1252"%>
<%
    Integer id = null;
    List<TarefaBean> tarefas = null;

    String idParam = request.getParameter("id_tarefas");
    String novoOuEditar = request.getParameter("novoOuEditar");


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
                    <div id="campos-cadastro" class="opaco">
                        <input type="hidden" name="id_tarefas" id="id_tarefas" value="<%= tarefa.getId_tarefas()%>" />
                        <input type="text" name="titulo" id="titulo" placeholder="Título da tarefa" value="<%= tarefa.getTitulo()%>" required>
                        <input type="text" name="responsavel" id="responsavel" placeholder="Responsável da tarefa" value="<%= tarefa.getResponsavel()%>" required>

                        <textarea  name="descricao" id="descricao" placeholder="Descrição da tarefa"><%= tarefa.getDescricao()%></textarea>

                        <div class="linha">
                            <select name="prioridade" id="prioridade">
                                <option value="baixa" <%= "baixa".equals(tarefa.getPrioridade()) ? "selected" : "" %>>Baixa</option>
                                <option value="media" <%= "media".equals(tarefa.getPrioridade()) ? "selected" : "" %>>Média</option>
                                <option value="alta" <%= "alta".equals(tarefa.getPrioridade()) ? "selected" : "" %>>Alta</option>
                            </select>


                            <select name="status" id="status">
                                <option value="pendente"><%= tarefa.getStatus()%></option>
                                <option value="feito">Feito</option>
                            </select>
                        </div>

                        <label for="data">Data prevista para conclusão</label>
                        <input type="date" name="data" id="data" value="2025-07-18">
                    </div>
                    <div class="botoes">
                    <% if (novoOuEditar != null && novoOuEditar.equals(0)) { %>
                        <button type="submit" class="salvar">Salvar</button>
                        <button type="reset" class="fechar" onclick="desartivarEdicao()">Cancelar</button>
                    <% } else { %>
                        <button id="btn-salvar" type="submit" class="salvar oculto">Salvar</button>
                        <button id="btn-cancelar" type="reset" class="fechar oculto" onclick="desartivarEdicao()">Cancelar</button>                    
                        <button id="btn-editar" type="reset" class="editar"  onclick="ativarEdicao()">Editar</button>
                    <% }  %>

                    </div>
                </form>

                <hr>

                <div class="">
                    <h2>Subtarefa</h2>
                    <form id="form-subtarefa" class="form" action="salvarSubtarefa.jsp" method="post">
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
            </div>


            <!-- DETAIL -->
            <div id="area-detail" class="detail">

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
                    
                <!--FORMULARIO PARA NOVO REGISTRO-->
                <form id="formTarefa" method="get" action="salvarTarefa.jsp">
                    <input type="hidden" name="id_tarefas" id="id_tarefas" value="0" />
                    <input type="text" name="titulo" id="titulo" placeholder="Título da tarefa" value="APAGAR" required>
                    <input type="text" name="responsavel" id="responsavel" placeholder="Responsável da tarefa" value="APAGAR" required>

                    <textarea  name="descricao" id="descricao" placeholder="Descrição da tarefa">Lorem Ipsum is simply dummy text of the printing and </textarea>

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
            </div>


            <!-- DETAIL -->
            <div class="detail opaco">
                <h2>Lista de subtarefas</h2>

                <ul id="lista-tarefas">
                </ul>
            </div>
        <% }%>

            </div>
        </div>

        <script src="./js/script.js"></script>

    </body>

</html>