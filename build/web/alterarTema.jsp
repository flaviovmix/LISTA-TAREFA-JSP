<%@page import="app.configuracao.ConfiguracaoDAO"%>
<%@page import="app.subtarefa.SubtarefaDAO"%>
<%@page contentType="text/html;charset=UTF-8" language="java" %>

<%
    int id_configuracao = Integer.parseInt(request.getParameter("id_configuracao"));
    int tema = Integer.parseInt(request.getParameter("tema"));

    ConfiguracaoDAO dao = new ConfiguracaoDAO();
    dao.alterarTema(tema, id_configuracao);
    dao.fecharConexao();
    
    out.println("id_configuracao: " + id_configuracao);
    out.println("<br>tema " + tema);
    
    response.sendRedirect("index.jsp?configuracao=1");
%>
