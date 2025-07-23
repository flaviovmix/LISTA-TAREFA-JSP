<%@page import="app.subtarefa.SubtarefaDAO"%>
<%@page import="app.subtarefa.SubtarefaBean"%>
<%@page import="app.MinhaConexao"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    SubtarefaBean subtarefa = new SubtarefaBean();
    SubtarefaDAO dao = new SubtarefaDAO();

    subtarefa.setDescricao(request.getParameter("descricao"));
    subtarefa.setFk_tarefa (Integer.parseInt(request.getParameter("fk_tarefa")));
    dao.adicionarSubtarefa(subtarefa);
    response.sendRedirect("novaTarefa.jsp?novoOuEditar=1");
%>
