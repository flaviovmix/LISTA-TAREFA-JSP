package app.tarefas;

import app.subtarefa.SubtarefaBean;
import app.MinhaConexao;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class TarefaDAO {

    private MinhaConexao dataBase;

    public TarefaDAO() {
        dataBase = new MinhaConexao("lista_tarefas");
        dataBase.abrirConexao();
    }

    public void select(TarefaBean tarefa) throws SQLException {

        try {
            String sql = "SELECT * FROM tarefas where id_tarefas = " + tarefa.getId_tarefas() + ";";

            PreparedStatement ps = dataBase.getConexao().prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                tarefa.setTitulo(rs.getString("titulo"));
                tarefa.setDescricao(rs.getString("descricao"));
                tarefa.setStatus(rs.getString("status"));
                tarefa.setPrioridade(rs.getString("prioridade"));
                tarefa.setResponsavel(rs.getString("responsavel"));
                tarefa.setData_criacao(rs.getDate("data_criacao"));
                tarefa.setData_conclusao(rs.getDate("data_conclusao"));
            }
            rs.close();
            ps.close();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void adicionarTarefa(TarefaBean tarefa) throws SQLException {

        PreparedStatement ps;

        String sql = "INSERT INTO tarefas "
                + "(titulo, descricao, status, prioridade, responsavel) VALUES "
                + "(     ?,         ?,      ?,          '" + tarefa.getPrioridade() + "',           ?)";

        ps = dataBase.getConexao().prepareStatement(sql);

        ps.setString(1, tarefa.getTitulo());
        ps.setString(2, tarefa.getDescricao());
        ps.setString(3, tarefa.getStatus());
        ps.setString(4, tarefa.getResponsavel());

        ps.executeUpdate();
        ps.close();

        maxId(tarefa);

    }

    public void maxId(TarefaBean tarefa) throws SQLException {

        try {
            String sql = "SELECT max(id_tarefas) as id_tarefas FROM tarefas;";

            PreparedStatement ps = dataBase.getConexao().prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                tarefa.setId_tarefas(rs.getInt("id_tarefas"));
            }
            rs.close();
            ps.close();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void alterarTarefa(TarefaBean tarefa) throws SQLException {

        PreparedStatement ps;

        String sql = "UPDATE tarefas set "
                + " titulo = '" + tarefa.getTitulo() + "', "
                + "descricao = '" + tarefa.getDescricao() + "', "
                + "status = '" + tarefa.getStatus() + "', "
                + "prioridade = '" + tarefa.getPrioridade() + "', "
                + "responsavel = '" + tarefa.getResponsavel() + "' "
                + " where id_tarefas = " + tarefa.getId_tarefas() + " ";

        ps = dataBase.getConexao().prepareStatement(sql);
        ps.executeUpdate();

        ps.close();

    }

    public void excluirTarefa(Integer id_tarefas) throws SQLException {
        PreparedStatement ps;
        String sql;
        sql = ("DELETE FROM tarefas WHERE id_tarefas=?");

        ps = dataBase.getConexao().prepareStatement(sql);
        ps.setInt(1, id_tarefas);
        ps.executeUpdate();

    }

    public List<TarefaBean> listarTarefas() throws SQLException {

        List<TarefaBean> tarefas = new ArrayList<>();

        try {
            String sql = "SELECT * FROM tarefas;";

            PreparedStatement ps = dataBase.getConexao().prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                TarefaBean tarefa = new TarefaBean();

                tarefa.setId_tarefas(rs.getInt("id_tarefas"));
                tarefa.setTitulo(rs.getString("titulo"));
                tarefa.setDescricao(rs.getString("descricao"));
                tarefa.setStatus(rs.getString("status"));
                tarefa.setPrioridade(rs.getString("prioridade"));
                tarefa.setResponsavel(rs.getString("responsavel"));
                tarefa.setData_criacao(rs.getDate("data_criacao"));
                tarefa.setData_conclusao(rs.getDate("data_conclusao"));

                tarefas.add(tarefa);
            }
            rs.close();
            ps.close();

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return tarefas;
    }

    public List<TarefaBean> listarTarefasComSubtarefas(Integer id_tarefas) throws SQLException {
    List<TarefaBean> listaTarefas = new ArrayList<>();
    Map<Integer, TarefaBean> mapaTarefas = new LinkedHashMap<>();

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT ")
           .append("t.id_tarefas, ")
           .append("t.titulo, ")
           .append("t.descricao AS descricao_tarefa, ")
           .append("t.status, ")
           .append("t.prioridade, ")
           .append("t.responsavel, ")
           .append("t.data_criacao, ")
           .append("t.data_conclusao AS data_conclusao_tarefa, ")
           .append("d.id_detalhe, ")
           .append("d.fk_tarefa, ")
           .append("d.descricao AS descricao_detalhe, ")
           .append("d.data_conclusao AS data_conclusao_detalhe ")
           .append("FROM tarefas t ")
           .append("LEFT JOIN detalhes_tarefa d ON t.id_tarefas = d.fk_tarefa ");

        if (id_tarefas != null) {
            sql.append("WHERE t.id_tarefas = ? ");
        }

        sql.append("ORDER BY d.id_detalhe DESC");


        try (PreparedStatement ps = dataBase.getConexao().prepareStatement(sql.toString())) {

            if (id_tarefas != null) {
                ps.setInt(1, id_tarefas);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int idTarefa = rs.getInt("id_tarefas");

                    TarefaBean tarefa = mapaTarefas.get(idTarefa);
                    if (tarefa == null) {
                        tarefa = new TarefaBean();
                        tarefa.setId_tarefas(idTarefa);
                        tarefa.setTitulo(rs.getString("titulo"));
                        tarefa.setDescricao(rs.getString("descricao_tarefa"));
                        tarefa.setStatus(rs.getString("status"));
                        tarefa.setPrioridade(rs.getString("prioridade"));
                        tarefa.setResponsavel(rs.getString("responsavel"));
                        tarefa.setData_criacao(rs.getDate("data_criacao"));
                        tarefa.setData_conclusao(rs.getDate("data_conclusao_tarefa"));
                        tarefa.setSubtarefas(new ArrayList<>());
                        mapaTarefas.put(idTarefa, tarefa);
                    }

                    int idDetalhe = rs.getInt("id_detalhe");
                    if (!rs.wasNull()) {
                        SubtarefaBean subtarefa = new SubtarefaBean();
                        subtarefa.setId_detalhe(idDetalhe);
                        subtarefa.setFk_tarefa(idTarefa);
                        subtarefa.setDescricao(rs.getString("descricao_detalhe"));
                        subtarefa.setData_conclusao(rs.getString("data_conclusao_detalhe"));

                        tarefa.getSubtarefas().add(subtarefa);
                    }
                }

                listaTarefas.addAll(mapaTarefas.values());
            }

        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }

    return listaTarefas;
    }


    public TarefaBean buscarPorId(int id) {
        TarefaBean tarefa = null;
        try {
            Connection con = dataBase.getConexao();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM tarefas WHERE id_tarefas = ?");
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                tarefa = new TarefaBean();
                tarefa.setId_tarefas(rs.getInt("id_tarefas"));
                tarefa.setTitulo(rs.getString("titulo"));
                tarefa.setDescricao(rs.getString("descricao"));
                tarefa.setStatus(rs.getString("status"));
                tarefa.setPrioridade(rs.getString("prioridade"));
                tarefa.setResponsavel(rs.getString("responsavel"));
                //tarefa.setData_criacao(rs.getDate("data_criacao"));
                //tarefa.setData_conclusao(rs.getDate("data_conclusao"));
            }
            rs.close();
            ps.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return tarefa;
    }

}
