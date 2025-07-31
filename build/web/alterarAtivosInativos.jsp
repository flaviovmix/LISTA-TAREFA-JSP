<%@page import="app.subtarefa.SubtarefaDAO"%>
<%@page contentType="text/html;charset=UTF-8" language="java" %>

<%
    int id_detalhe = Integer.parseInt(request.getParameter("id_detalhe"));
    int id_tarefas = Integer.parseInt(request.getParameter("id_tarefas"));

    boolean estadoAtual = Boolean.parseBoolean(request.getParameter("estado_atual"));

    boolean novoEstado = !estadoAtual;

    SubtarefaDAO dao = new SubtarefaDAO();
    dao.alterarAtivoInativo(id_detalhe, novoEstado);

    dao.fecharConexao();

    response.sendRedirect("novaTarefa.jsp?id_tarefas=" + id_tarefas +"&novoOuEditar=1");
%>
