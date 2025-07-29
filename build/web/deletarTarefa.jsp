<%@page import="app.tarefas.TarefaDAO"%>
<%@page import="app.tarefas.TarefaBean"%>
<%
    int codigo = Integer.parseInt(request.getParameter("id_tarefas"));

    TarefaBean tarefa = new TarefaBean();            
    TarefaDAO dao = new TarefaDAO();
    dao.excluirTarefa(codigo);
    dao.fecharConexao();
    
    response.sendRedirect("index.jsp");
    dao.fecharConexao();
%>