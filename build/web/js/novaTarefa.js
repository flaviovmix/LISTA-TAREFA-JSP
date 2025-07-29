function link(url) {
    self.location.href=url;
}

function selecionarAddSubTarefa() {
    document.getElementById("descricaoDetail").focus();
}

const descricaoDetail = document.getElementById("descricaoDetail");

if (descricaoDetail) {
    descricaoDetail.addEventListener("keydown", function (e) {
        if (e.key === "Enter" && !e.shiftKey) {
            e.preventDefault(); // Impede quebra de linha
            document.getElementById("form-subtarefa").submit(); // Envia o formulário
        }
    });
}