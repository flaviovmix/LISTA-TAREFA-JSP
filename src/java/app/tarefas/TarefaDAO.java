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
            String sql = "SELECT a.*, (select count(*) from detalhes_tarefa b where b.fk_tarefa=a.id_tarefas) as subtarefas_count FROM tarefas a";

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
                tarefa.setSubtarefas_counts(rs.getInt("subtarefas_count"));

                tarefas.add(tarefa);
            }
            rs.close();
            ps.close();

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return tarefas;
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
