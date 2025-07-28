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

    public List<SubtarefaBean> listarPorTarefa(int idTarefa) {
        List<SubtarefaBean> lista = new ArrayList<>();

        try {
            String sql = "SELECT * FROM detalhes_tarefa WHERE fk_tarefa = ?";
            PreparedStatement ps = dataBase.getConexao().prepareStatement(sql);
            ps.setInt(1, idTarefa);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                SubtarefaBean s = new SubtarefaBean();
                s.setId_detalhe(rs.getInt("id_detalhe"));
                s.setFk_tarefa(rs.getInt("fk_tarefa"));
                s.setDescricao(rs.getString("descricao"));
                s.setData_conclusao(rs.getString("data_conclusao"));
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
    
    public void listarSubTarefas(SubtarefaBean subtarefa) {
        
    }
    
}
