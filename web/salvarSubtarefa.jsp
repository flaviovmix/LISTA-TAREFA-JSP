<%@page import="app.MinhaConexao"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String descricao = request.getParameter("descricao");
    String data_conclusao = request.getParameter("data_conclusao");
    String fk_tarefa = request.getParameter("fk_tarefa");

    try {
        MinhaConexao conexao = new MinhaConexao("lista_tarefas");
        conexao.abrirConexao();

        String sql = "INSERT INTO detalhes_tarefa (fk_tarefa, descricao) VALUES (?, ?)";
        java.sql.PreparedStatement ps = conexao.getConexao().prepareStatement(sql);

        ps.setInt(1, Integer.parseInt(fk_tarefa));
        ps.setString(2, descricao);
       // ps.setString(3, data_conclusao);

        ps.executeUpdate();
        ps.close();

        // Redireciona de volta para a tela de edição da tarefa
        response.sendRedirect("novaTarefa.jsp?id_tarefas=" + fk_tarefa);

    } catch (Exception e) {
        out.println("Erro ao salvar subtarefa: " + e.getMessage());
    }
%>
