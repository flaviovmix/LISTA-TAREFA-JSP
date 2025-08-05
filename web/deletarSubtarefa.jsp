<%@page import="app.subtarefa.SubtarefaDAO"%>
<%@page import="app.subtarefa.SubtarefaBean"%>
<%@page import="app.MinhaConexao"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    SubtarefaBean subtarefa = new SubtarefaBean();
    SubtarefaDAO dao = new SubtarefaDAO();

    subtarefa.setFk_tarefa(Integer.parseInt(request.getParameter("id-detalhe")));
    String id_tarefa = (request.getParameter("id-tarefa"));


    dao.deletarSubtarefa(subtarefa);
    response.sendRedirect("novaTarefa.jsp?id_tarefa=" + id_tarefa +"&novoOuEditar=1");

    dao.fecharConexao();
%>
