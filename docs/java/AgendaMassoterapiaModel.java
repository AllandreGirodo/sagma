//
//package com.agenda.massoterapia;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

class UsuarioModel {
    private String id;
    private String nome;
    private String email;
    private String tipo;
    private boolean aprovado;
    private boolean reprovado;
    private LocalDateTime dataCadastro;
    private boolean lgpdConsentido;
    private LocalDateTime lgpdConsentimentoEm;

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getTipo() { return tipo; }
    public void setTipo(String tipo) { this.tipo = tipo; }
    public boolean isAprovado() { return aprovado; }
    public void setAprovado(boolean aprovado) { this.aprovado = aprovado; }
    public boolean isReprovado() { return reprovado; }
    public void setReprovado(boolean reprovado) { this.reprovado = reprovado; }
    public LocalDateTime getDataCadastro() { return dataCadastro; }
    public void setDataCadastro(LocalDateTime dataCadastro) { this.dataCadastro = dataCadastro; }
    public boolean isLgpdConsentido() { return lgpdConsentido; }
    public void setLgpdConsentido(boolean lgpdConsentido) { this.lgpdConsentido = lgpdConsentido; }
    public LocalDateTime getLgpdConsentimentoEm() { return lgpdConsentimentoEm; }
    public void setLgpdConsentimentoEm(LocalDateTime lgpdConsentimentoEm) { this.lgpdConsentimentoEm = lgpdConsentimentoEm; }
}

class Cliente {
    private String idCliente;
    private String nomeCliente;
    private String nomePreferidoCliente;
    private String telefonePrincipalCliente;
    private String cpfCliente;
    private String enderecoCliente;
    private int saldoSessoesCliente;
    private boolean anamneseOkCliente;
    private Map<String, Boolean> agendaFixaSemanaCliente;

    public String getIdCliente() { return idCliente; }
    public void setIdCliente(String idCliente) { this.idCliente = idCliente; }
    public String getNomeCliente() { return nomeCliente; }
    public void setNomeCliente(String nomeCliente) { this.nomeCliente = nomeCliente; }
    public String getNomePreferidoCliente() { return nomePreferidoCliente; }
    public void setNomePreferidoCliente(String nomePreferidoCliente) { this.nomePreferidoCliente = nomePreferidoCliente; }
    public String getTelefonePrincipalCliente() { return telefonePrincipalCliente; }
    public void setTelefonePrincipalCliente(String telefonePrincipalCliente) { this.telefonePrincipalCliente = telefonePrincipalCliente; }
    public String getCpfCliente() { return cpfCliente; }
    public void setCpfCliente(String cpfCliente) { this.cpfCliente = cpfCliente; }
    public String getEnderecoCliente() { return enderecoCliente; }
    public void setEnderecoCliente(String enderecoCliente) { this.enderecoCliente = enderecoCliente; }
    public int getSaldoSessoesCliente() { return saldoSessoesCliente; }
    public void setSaldoSessoesCliente(int saldoSessoesCliente) { this.saldoSessoesCliente = saldoSessoesCliente; }
    public boolean isAnamneseOkCliente() { return anamneseOkCliente; }
    public void setAnamneseOkCliente(boolean anamneseOkCliente) { this.anamneseOkCliente = anamneseOkCliente; }
    public Map<String, Boolean> getAgendaFixaSemanaCliente() { return agendaFixaSemanaCliente; }
    public void setAgendaFixaSemanaCliente(Map<String, Boolean> agendaFixaSemanaCliente) { this.agendaFixaSemanaCliente = agendaFixaSemanaCliente; }
}

class Agendamento {
    private String id;
    private String clienteId;
    private LocalDateTime dataHora;
    private String tipo;
    private String status;
    private String motivoCancelamento;
    private LocalDateTime dataCriacao;
    private String clienteNomeSnapshot;
    private String clienteTelefoneSnapshot;
    private double valorOriginal;
    private double valorFinal;
    private String administradoraAtrelada;
    private Cliente cliente;
    private List<ChatMensagem> mensagens;
    private List<TransacaoFinanceira> transacoes;
    private List<ItemEstoque> itensEstoqueConsumidos;
    private CupomModel cupom;

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public String getClienteId() { return clienteId; }
    public void setClienteId(String clienteId) { this.clienteId = clienteId; }
    public LocalDateTime getDataHora() { return dataHora; }
    public void setDataHora(LocalDateTime dataHora) { this.dataHora = dataHora; }
    public String getTipo() { return tipo; }
    public void setTipo(String tipo) { this.tipo = tipo; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getMotivoCancelamento() { return motivoCancelamento; }
    public void setMotivoCancelamento(String motivoCancelamento) { this.motivoCancelamento = motivoCancelamento; }
    public LocalDateTime getDataCriacao() { return dataCriacao; }
    public void setDataCriacao(LocalDateTime dataCriacao) { this.dataCriacao = dataCriacao; }
    public String getClienteNomeSnapshot() { return clienteNomeSnapshot; }
    public void setClienteNomeSnapshot(String clienteNomeSnapshot) { this.clienteNomeSnapshot = clienteNomeSnapshot; }
    public String getClienteTelefoneSnapshot() { return clienteTelefoneSnapshot; }
    public void setClienteTelefoneSnapshot(String clienteTelefoneSnapshot) { this.clienteTelefoneSnapshot = clienteTelefoneSnapshot; }
    public double getValorOriginal() { return valorOriginal; }
    public void setValorOriginal(double valorOriginal) { this.valorOriginal = valorOriginal; }
    public double getValorFinal() { return valorFinal; }
    public void setValorFinal(double valorFinal) { this.valorFinal = valorFinal; }
    public String getAdministradoraAtrelada() { return administradoraAtrelada; }
    public void setAdministradoraAtrelada(String administradoraAtrelada) { this.administradoraAtrelada = administradoraAtrelada; }
    public Cliente getCliente() { return cliente; }
    public void setCliente(Cliente cliente) { this.cliente = cliente; }
    public List<ChatMensagem> getMensagens() { return mensagens; }
    public void setMensagens(List<ChatMensagem> mensagens) { this.mensagens = mensagens; }
    public List<TransacaoFinanceira> getTransacoes() { return transacoes; }
    public void setTransacoes(List<TransacaoFinanceira> transacoes) { this.transacoes = transacoes; }
    public List<ItemEstoque> getItensEstoqueConsumidos() { return itensEstoqueConsumidos; }
    public void setItensEstoqueConsumidos(List<ItemEstoque> itensEstoqueConsumidos) { this.itensEstoqueConsumidos = itensEstoqueConsumidos; }
    public CupomModel getCupom() { return cupom; }
    public void setCupom(CupomModel cupom) { this.cupom = cupom; }
}

class TransacaoFinanceira {
    private String id;
    private String agendamentoId;
    private String clienteUid;
    private double valorBruto;
    private double valorDesconto;
    private double valorLiquido;
    private String metodoPagamento;
    private String statusPagamento;
    private LocalDateTime dataPagamento;
    private String criadoPorUid;
    private Agendamento agendamento;

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public String getAgendamentoId() { return agendamentoId; }
    public void setAgendamentoId(String agendamentoId) { this.agendamentoId = agendamentoId; }
    public String getClienteUid() { return clienteUid; }
    public void setClienteUid(String clienteUid) { this.clienteUid = clienteUid; }
    public double getValorBruto() { return valorBruto; }
    public void setValorBruto(double valorBruto) { this.valorBruto = valorBruto; }
    public double getValorDesconto() { return valorDesconto; }
    public void setValorDesconto(double valorDesconto) { this.valorDesconto = valorDesconto; }
    public double getValorLiquido() { return valorLiquido; }
    public void setValorLiquido(double valorLiquido) { this.valorLiquido = valorLiquido; }
    public String getMetodoPagamento() { return metodoPagamento; }
    public void setMetodoPagamento(String metodoPagamento) { this.metodoPagamento = metodoPagamento; }
    public String getStatusPagamento() { return statusPagamento; }
    public void setStatusPagamento(String statusPagamento) { this.statusPagamento = statusPagamento; }
    public LocalDateTime getDataPagamento() { return dataPagamento; }
    public void setDataPagamento(LocalDateTime dataPagamento) { this.dataPagamento = dataPagamento; }
    public String getCriadoPorUid() { return criadoPorUid; }
    public void setCriadoPorUid(String criadoPorUid) { this.criadoPorUid = criadoPorUid; }
    public Agendamento getAgendamento() { return agendamento; }
    public void setAgendamento(Agendamento agendamento) { this.agendamento = agendamento; }
}

class ConfigModel {
    private Map<String, Boolean> camposObrigatorios;
    private double horasAntecedenciaCancelamento;
    private int inicioSono;
    private int fimSono;
    private double precoSessao;
    private boolean biometriaAtiva;
    private boolean chatAtivo;
    private int statusCampoCupom;
    private boolean reciboLeitura;
    private List<String> mensagensAleatoriasClientes;

    public Map<String, Boolean> getCamposObrigatorios() { return camposObrigatorios; }
    public void setCamposObrigatorios(Map<String, Boolean> camposObrigatorios) { this.camposObrigatorios = camposObrigatorios; }
    public double getHorasAntecedenciaCancelamento() { return horasAntecedenciaCancelamento; }
    public void setHorasAntecedenciaCancelamento(double horasAntecedenciaCancelamento) { this.horasAntecedenciaCancelamento = horasAntecedenciaCancelamento; }
    public int getInicioSono() { return inicioSono; }
    public void setInicioSono(int inicioSono) { this.inicioSono = inicioSono; }
    public int getFimSono() { return fimSono; }
    public void setFimSono(int fimSono) { this.fimSono = fimSono; }
    public double getPrecoSessao() { return precoSessao; }
    public void setPrecoSessao(double precoSessao) { this.precoSessao = precoSessao; }
    public boolean isBiometriaAtiva() { return biometriaAtiva; }
    public void setBiometriaAtiva(boolean biometriaAtiva) { this.biometriaAtiva = biometriaAtiva; }
    public boolean isChatAtivo() { return chatAtivo; }
    public void setChatAtivo(boolean chatAtivo) { this.chatAtivo = chatAtivo; }
    public int getStatusCampoCupom() { return statusCampoCupom; }
    public void setStatusCampoCupom(int statusCampoCupom) { this.statusCampoCupom = statusCampoCupom; }
    public boolean isReciboLeitura() { return reciboLeitura; }
    public void setReciboLeitura(boolean reciboLeitura) { this.reciboLeitura = reciboLeitura; }
    public List<String> getMensagensAleatoriasClientes() { return mensagensAleatoriasClientes; }
    public void setMensagensAleatoriasClientes(List<String> mensagensAleatoriasClientes) { this.mensagensAleatoriasClientes = mensagensAleatoriasClientes; }
}

class ItemEstoque {
    private String id;
    private String nome;
    private int quantidade;
    private boolean consumoAutomatico;

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }
    public int getQuantidade() { return quantidade; }
    public void setQuantidade(int quantidade) { this.quantidade = quantidade; }
    public boolean isConsumoAutomatico() { return consumoAutomatico; }
    public void setConsumoAutomatico(boolean consumoAutomatico) { this.consumoAutomatico = consumoAutomatico; }
}

class CupomModel {
    private String codigo;
    private String tipo;
    private double valor;
    private LocalDateTime validade;
    private boolean ativo;

    public String getCodigo() { return codigo; }
    public void setCodigo(String codigo) { this.codigo = codigo; }
    public String getTipo() { return tipo; }
    public void setTipo(String tipo) { this.tipo = tipo; }
    public double getValor() { return valor; }
    public void setValor(double valor) { this.valor = valor; }
    public LocalDateTime getValidade() { return validade; }
    public void setValidade(LocalDateTime validade) { this.validade = validade; }
    public boolean isAtivo() { return ativo; }
    public void setAtivo(boolean ativo) { this.ativo = ativo; }
}

class ChatMensagem {
    private String id;
    private String texto;
    private String tipo;
    private String autorId;
    private LocalDateTime dataHora;
    private boolean lida;

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public String getTexto() { return texto; }
    public void setTexto(String texto) { this.texto = texto; }
    public String getTipo() { return tipo; }
    public void setTipo(String tipo) { this.tipo = tipo; }
    public String getAutorId() { return autorId; }
    public void setAutorId(String autorId) { this.autorId = autorId; }
    public LocalDateTime getDataHora() { return dataHora; }
    public void setDataHora(LocalDateTime dataHora) { this.dataHora = dataHora; }
    public boolean isLida() { return lida; }
    public void setLida(boolean lida) { this.lida = lida; }
}

class LogModel {
    private String tipo;
    private String mensagem;
    private LocalDateTime dataHora;
    private String usuarioId;

    public String getTipo() { return tipo; }
    public void setTipo(String tipo) { this.tipo = tipo; }
    public String getMensagem() { return mensagem; }
    public void setMensagem(String mensagem) { this.mensagem = mensagem; }
    public LocalDateTime getDataHora() { return dataHora; }
    public void setDataHora(LocalDateTime dataHora) { this.dataHora = dataHora; }
    public String getUsuarioId() { return usuarioId; }
    public void setUsuarioId(String usuarioId) { this.usuarioId = usuarioId; }
}

class AppSoftwareConfigModel {
    private String currentVersion;
    private String minRequiredVersion;
    private List<ChangeLogModel> changeLogs;

    public String getCurrentVersion() { return currentVersion; }
    public void setCurrentVersion(String currentVersion) { this.currentVersion = currentVersion; }
    public String getMinRequiredVersion() { return minRequiredVersion; }
    public void setMinRequiredVersion(String minRequiredVersion) { this.minRequiredVersion = minRequiredVersion; }
    public List<ChangeLogModel> getChangeLogs() { return changeLogs; }
    public void setChangeLogs(List<ChangeLogModel> changeLogs) { this.changeLogs = changeLogs; }
}

class ChangeLogModel {
    private String versao;
    private LocalDateTime data;
    private List<String> mudancas;
    private String titulo;
    private boolean critical;
    private String autor;

    public String getVersao() { return versao; }
    public void setVersao(String versao) { this.versao = versao; }
    public LocalDateTime getData() { return data; }
    public void setData(LocalDateTime data) { this.data = data; }
    public List<String> getMudancas() { return mudancas; }
    public void setMudancas(List<String> mudancas) { this.mudancas = mudancas; }
    public String getTitulo() { return titulo; }
    public void setTitulo(String titulo) { this.titulo = titulo; }
    public boolean isCritical() { return critical; }
    public void setCritical(boolean critical) { this.critical = critical; }
    public String getAutor() { return autor; }
    public void setAutor(String autor) { this.autor = autor; }
}