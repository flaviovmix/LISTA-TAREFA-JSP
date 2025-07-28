package app;

public class Utilidades {
    public static String nullTrim(Integer valor){
        if(valor == null){
            return "";
        } else {
            return valor.toString();
        }
    }

    public static String nullTrim(String valor){
        if(valor == null){
            return "";
        } else {
            return valor.trim();
        }
    }
}
