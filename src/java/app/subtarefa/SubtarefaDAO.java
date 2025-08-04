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
    
    public void adicionarSubtarefa(SubtarefaBean subtarefa) {
        
        String sql = "INSERT INTO detalhes_tarefa (fk_tarefa, descricao) VALUES (?, ?)";
        
        try ( PreparedStatement ps = dataBase.getConexao().prepareStatement(sql);) {
            
            ps.setInt(1, subtarefa.getFk_tarefa());
            ps.setString(2, subtarefa.getDescricao());

            ps.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }

    }
    
    public void deletarSubtarefa(SubtarefaBean subtarefa) {
        String sql = "DELETE FROM detalhes_tarefa WHERE id_detalhe = ?;";
        
        try (PreparedStatement ps = dataBase.getConexao().prepareStatement(sql)) {
            
            ps.setInt(1, subtarefa.getFk_tarefa());       
            ps.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }        
    }    
  
    public List<SubtarefaBean> listaTarefasAtivas(int idTarefa) {
        return listarTarefasAtivoEInativas(idTarefa, true);
    }
    public List<SubtarefaBean> listaTarefasInativas(int idTarefa) {
        return listarTarefasAtivoEInativas(idTarefa, false);
    }
    private List<SubtarefaBean> listarTarefasAtivoEInativas(int idTarefa, boolean ativoOuInativo) {
        List<SubtarefaBean> lista = new ArrayList<>();
        
        String sql = "SELECT * FROM detalhes_tarefa WHERE fk_tarefa = ? AND ativo = ?";
        
        try (PreparedStatement ps = dataBase.getConexao().prepareStatement(sql);) {
            
            ps.setInt(1, idTarefa);
            ps.setBoolean(2, ativoOuInativo);
            
            try (ResultSet rs = ps.executeQuery();) {

                while (rs.next()) {
                    SubtarefaBean subtarefa = new SubtarefaBean();
                    subtarefa.setId_detalhe(rs.getInt("id_detalhe"));
                    subtarefa.setFk_tarefa(rs.getInt("fk_tarefa"));
                    subtarefa.setDescricao(rs.getString("descricao"));
                    subtarefa.setData_conclusao(rs.getString("data_conclusao"));
                    subtarefa.setAtivo(rs.getBoolean("ativo"));
                    lista.add(subtarefa);
                }
                
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return lista;
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
    
    public void fecharConexao() {
        dataBase.fecharConexao();
    }
    
}
