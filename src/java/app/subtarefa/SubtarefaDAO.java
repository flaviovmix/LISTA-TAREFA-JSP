package app.subtarefa;

import app.MinhaConexao;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SubtarefaDAO {
    private MinhaConexao dataBase;

    public SubtarefaDAO() {
        dataBase = new MinhaConexao("lista_tarefas");
        dataBase.abrirConexao();
    }
    
    public List<SubtarefaBean> listarAtivasPorTarefa(int idTarefa) {
        return listarPorTarefaEAtivo(idTarefa, true);
    }

    public List<SubtarefaBean> listarInativasPorTarefa(int idTarefa) {
        return listarPorTarefaEAtivo(idTarefa, false);
    }

    private List<SubtarefaBean> listarPorTarefaEAtivo(int idTarefa, boolean ativoOuInativo) {
        List<SubtarefaBean> lista = new ArrayList<>();

        try {
            String sql = "SELECT * FROM detalhes_tarefa WHERE fk_tarefa = ? AND ativo = ?";
            PreparedStatement ps = dataBase.getConexao().prepareStatement(sql);
            ps.setInt(1, idTarefa);
            ps.setBoolean(2, ativoOuInativo);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                SubtarefaBean s = new SubtarefaBean();
                s.setId_detalhe(rs.getInt("id_detalhe"));
                s.setFk_tarefa(rs.getInt("fk_tarefa"));
                s.setDescricao(rs.getString("descricao"));
                s.setData_conclusao(rs.getString("data_conclusao"));
                s.setAtivo(rs.getBoolean("ativo"));
                lista.add(s);
            }

            rs.close();
            ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return lista;
    }
    
    public void adicionarSubtarefa(SubtarefaBean subtarefa) throws SQLException {
        
        PreparedStatement ps;
        
        String sql = "INSERT INTO detalhes_tarefa (fk_tarefa, descricao) VALUES (?, ?)";
        
        ps = dataBase.getConexao().prepareStatement(sql);
        
        ps.setInt(1, subtarefa.getFk_tarefa());
        ps.setString(2, subtarefa.getDescricao());
        
        ps.executeUpdate();
        ps.close();
        
    }
    
    public void alterarAtivoInativo(int id_detalhe, boolean ativo) {
        try {
            String sql = "UPDATE detalhes_tarefa SET ativo = ? WHERE id_detalhe = ?";
            PreparedStatement ps = dataBase.getConexao().prepareStatement(sql);

            ps.setBoolean(1, ativo);
            ps.setInt(2, id_detalhe);
            ps.executeUpdate();

            ps.close(); 
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public void deletarSubtarefa(SubtarefaBean subtarefa) throws SQLException {
        
        PreparedStatement ps;
        
        String sql = "DELETE FROM detalhes_tarefa WHERE id_detalhe = ?;";
        
        ps = dataBase.getConexao().prepareStatement(sql);
        
        ps.setInt(1, subtarefa.getFk_tarefa());
        
        ps.executeUpdate();
        ps.close();
        
    }    
    
    public void fecharConexao() {
        dataBase.fecharConexao();
    }
    
}
