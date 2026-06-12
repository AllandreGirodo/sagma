const { onCall, HttpsError } = require("firebase-functions/v2/https");
const { onDocumentCreated } = require("firebase-functions/v2/firestore");
const { onSchedule } = require("firebase-functions/v2/scheduler");
const admin = require("firebase-admin");
const { logger } = require("firebase-functions");

admin.initializeApp();

// ---------------------------------------------------------------------------
// LGPD — limpeza automática de logs com mais de 5 anos
// ---------------------------------------------------------------------------
/**
 * [RF008] Roda todo dia às 03:00. Exclui logs LGPD expirados em lotes de 500.
 */
exports.limparLogsLgpdAntigos = onSchedule("every day 03:00", async () => {
  const db = admin.firestore();
  const cincoAnosAtras = new Date();
  cincoAnosAtras.setFullYear(cincoAnosAtras.getFullYear() - 5);

  logger.info(`Limpeza LGPD: excluindo logs anteriores a ${cincoAnosAtras.toISOString()}`);

  const snapshot = await db
    .collection("lgpd_logs")
    .where("data", "<", admin.firestore.Timestamp.fromDate(cincoAnosAtras))
    .get();

  if (snapshot.empty) {
    logger.info("Nenhum log LGPD expirado encontrado.");
    return;
  }

  const batch = db.batch();
  snapshot.forEach((doc) => batch.delete(doc.ref));
  await batch.commit();

  logger.info(`Limpeza LGPD concluída: ${snapshot.size} logs excluídos.`);
});

// ---------------------------------------------------------------------------
// PUSH — Callable: envia notificação FCM para um token específico
// ---------------------------------------------------------------------------
/**
 * Chamada pelo app Flutter via FirebaseFunctions.instance.httpsCallable(name).
 * Payload esperado: { token: String, titulo: String, corpo: String }
 *
 * Configure PUSH_NOTIFICATION_FUNCTION_NAME=enviarPushNotificacao no .env.
 */
exports.enviarPushNotificacao = onCall({ region: "southamerica-east1" }, async (request) => {
  const { token, titulo, corpo } = request.data || {};

  if (!token || typeof token !== "string" || token.trim() === "") {
    throw new HttpsError("invalid-argument", "Campo 'token' ausente ou inválido.");
  }
  if (!titulo || !corpo) {
    throw new HttpsError("invalid-argument", "Campos 'titulo' e 'corpo' são obrigatórios.");
  }

  const message = {
    token: token.trim(),
    notification: { title: titulo, body: corpo },
    android: { priority: "high" },
    apns: { payload: { aps: { sound: "default" } } },
  };

  try {
    const response = await admin.messaging().send(message);
    logger.info(`Push enviado com sucesso: ${response}`);
    return { success: true, messageId: response };
  } catch (err) {
    logger.error(`Erro ao enviar push para token ${token.substring(0, 10)}...: ${err.message}`);
    throw new HttpsError("internal", `Falha ao enviar notificação: ${err.message}`);
  }
});

// ---------------------------------------------------------------------------
// PUSH — Trigger: notifica o admin quando uma nova solicitação de agendamento é criada
// ---------------------------------------------------------------------------
/**
 * Dispara automaticamente ao criar um documento em agendamentos/{id}.
 * Busca o FCM token do admin em configuracoes/geral.fcm_token_admin e envia push.
 */
exports.notificarNovoAgendamento = onDocumentCreated(
  { document: "agendamentos/{agendamentoId}", region: "southamerica-east1" },
  async (event) => {
    const db = admin.firestore();
    const dados = event.data?.data();

    if (!dados) {
      logger.warn("notificarNovoAgendamento: documento sem dados.");
      return;
    }

    const clienteNome = dados.cliente_nome_snapshot || dados.cliente_nome || "Cliente";
    const tipoMassagem = dados.tipo_massagem || dados.tipo || "massagem";
    const dataHora = dados.data_hora?.toDate
      ? dados.data_hora.toDate().toLocaleString("pt-BR", { timeZone: "America/Sao_Paulo" })
      : "horário não definido";

    // Busca todos os admins (tipo == 'admin' && aprovado == true) para notificar
    const adminsSnap = await db
      .collection("usuarios")
      .where("tipo", "==", "admin")
      .where("aprovado", "==", true)
      .get();

    if (adminsSnap.empty) {
      logger.info("notificarNovoAgendamento: nenhum admin encontrado.");
      return;
    }

    const titulo = "Nova solicitação de agendamento";
    const corpo = `${clienteNome} quer agendar ${tipoMassagem} em ${dataHora}`;

    const envios = adminsSnap.docs
      .map((doc) => doc.data().fcm_token)
      .filter((token) => token && token.trim() !== "")
      .map((token) => {
        const msg = {
          token,
          notification: { title: titulo, body: corpo },
          android: { priority: "high" },
          apns: { payload: { aps: { sound: "default" } } },
          data: {
            agendamento_id: event.params.agendamentoId,
            tipo: "novo_agendamento",
          },
        };
        return admin.messaging().send(msg).catch((err) => {
          logger.warn(`Falha ao notificar admin (token ...${token.slice(-6)}): ${err.message}`);
        });
      });

    await Promise.all(envios);
    logger.info(`notificarNovoAgendamento: ${envios.length} admin(s) notificados para agendamento ${event.params.agendamentoId}.`);
  }
);

// ---------------------------------------------------------------------------
// LEMBRETES — Callable: disparo manual de lembretes (usado pelo painel admin)
// ---------------------------------------------------------------------------
/**
 * Chamada pelo app: FirestoreService.dispararLembretes(horas: 24).
 * Busca agendamentos aprovados com data_hora em [agora+horas-30min, agora+horas+30min].
 * Envia push para o cliente correspondente.
 */
exports.enviarLembretesManual = onCall({ region: "southamerica-east1" }, async (request) => {
  const horas = typeof request.data?.horas === "number" ? request.data.horas : 24;
  const resultado = await _processarLembretes(horas);
  return resultado;
});

// ---------------------------------------------------------------------------
// LEMBRETES — Scheduled: lembrete automático diário (todo dia às 08:00)
// ---------------------------------------------------------------------------
exports.enviarLembretesDiarios = onSchedule(
  { schedule: "every day 08:00", timeZone: "America/Sao_Paulo", region: "southamerica-east1" },
  async () => {
    const resultado = await _processarLembretes(24);
    logger.info(`enviarLembretesDiarios concluído: ${JSON.stringify(resultado)}`);
  }
);

// ---------------------------------------------------------------------------
// Helper interno: processa lembretes para agendamentos na janela de X horas
// ---------------------------------------------------------------------------
async function _processarLembretes(horas) {
  const db = admin.firestore();
  const agora = new Date();
  const alvo = new Date(agora.getTime() + horas * 60 * 60 * 1000);
  // Janela de ±30 min em torno do alvo
  const inicio = new Date(alvo.getTime() - 30 * 60 * 1000);
  const fim = new Date(alvo.getTime() + 30 * 60 * 1000);

  logger.info(`Buscando agendamentos aprovados entre ${inicio.toISOString()} e ${fim.toISOString()}`);

  const agendamentosSnap = await db
    .collection("agendamentos")
    .where("status", "==", "aprovado")
    .where("data_hora", ">=", admin.firestore.Timestamp.fromDate(inicio))
    .where("data_hora", "<=", admin.firestore.Timestamp.fromDate(fim))
    .get();

  if (agendamentosSnap.empty) {
    logger.info("Nenhum agendamento para lembrete nesta janela.");
    return { enviados: 0, erros: 0, total: 0 };
  }

  let enviados = 0;
  let erros = 0;

  for (const doc of agendamentosSnap.docs) {
    const dados = doc.data();
    const clienteId = dados.cliente_id;
    if (!clienteId) continue;

    // Busca o token FCM do cliente via campo id no documento
    let fcmToken = null;
    try {
      // Tenta buscar por email_normalizado (chave do doc de usuário)
      const emailNorm = dados.cliente_email_snapshot;
      if (emailNorm) {
        const usuarioSnap = await db.collection("usuarios").doc(emailNorm).get();
        fcmToken = usuarioSnap.data()?.fcm_token || null;
      }
      // Fallback: busca por campo 'id' == clienteId
      if (!fcmToken) {
        const querySnap = await db.collection("usuarios")
          .where("id", "==", clienteId)
          .limit(1)
          .get();
        if (!querySnap.empty) {
          fcmToken = querySnap.docs[0].data().fcm_token || null;
        }
      }
    } catch (err) {
      logger.warn(`Erro ao buscar token do cliente ${clienteId}: ${err.message}`);
    }

    if (!fcmToken) {
      logger.info(`Sem token FCM para cliente ${clienteId} — lembrete pulado.`);
      continue;
    }

    const dataHoraStr = dados.data_hora?.toDate
      ? dados.data_hora.toDate().toLocaleString("pt-BR", { timeZone: "America/Sao_Paulo" })
      : "em breve";
    const tipoMassagem = dados.tipo_massagem || dados.tipo || "sua sessão";

    const mensagem = {
      token: fcmToken,
      notification: {
        title: "Lembrete de agendamento",
        body: `Sua sessão de ${tipoMassagem} está agendada para ${dataHoraStr}. Nos vemos em breve!`,
      },
      android: { priority: "high" },
      apns: { payload: { aps: { sound: "default" } } },
      data: { agendamento_id: doc.id, tipo: "lembrete" },
    };

    try {
      await admin.messaging().send(mensagem);
      enviados++;
      logger.info(`Lembrete enviado para cliente ${clienteId} (agendamento ${doc.id}).`);
    } catch (err) {
      erros++;
      logger.error(`Falha ao enviar lembrete para ${clienteId}: ${err.message}`);
    }
  }

  return { enviados, erros, total: agendamentosSnap.size };
}

// ---------------------------------------------------------------------------
// MENSAGENS ALEATÓRIAS — Callable: disparo manual de mensagens motivacionais
// ---------------------------------------------------------------------------
/**
 * Chamada pelo app: FirestoreService.dispararMensagensAleatoriasClientes().
 * Busca clientes aprovados e envia push com mensagem aleatória (ou selecionada).
 */
exports.dispararMensagensAleatoriasClientesManual = onCall(
  { region: "southamerica-east1" },
  async (request) => {
    const { dryRun = true, limite = 0, indiceMensagemSelecionada = -1 } = request.data || {};
    const db = admin.firestore();

    // Busca mensagens configuradas no banco
    const configSnap = await db.collection("configuracoes").doc("notificacoes").get();
    const mensagens = configSnap.data()?.mensagens_aleatorias || [
      "Seu bem-estar é nossa prioridade. Agende já sua sessão de massagem!",
      "Cuide-se! Uma sessão de massagem pode transformar o seu dia.",
      "Que tal um momento de relaxamento? Temos horários disponíveis para você.",
    ];

    const idx = indiceMensagemSelecionada >= 0 && indiceMensagemSelecionada < mensagens.length
      ? indiceMensagemSelecionada
      : Math.floor(Math.random() * mensagens.length);
    const mensagemSelecionada = mensagens[idx];

    // Busca clientes aprovados com token FCM
    let query = db.collection("usuarios")
      .where("tipo", "==", "cliente")
      .where("aprovado", "==", true);

    const snapshot = await query.get();
    const clientes = snapshot.docs.filter((d) => d.data().fcm_token);
    const alvos = limite > 0 ? clientes.slice(0, limite) : clientes;

    if (dryRun) {
      logger.info(`[DRY-RUN] Mensagem "${mensagemSelecionada}" seria enviada para ${alvos.length} cliente(s).`);
      return { dryRun: true, total: alvos.length, mensagem: mensagemSelecionada };
    }

    let enviados = 0;
    let erros = 0;

    for (const doc of alvos) {
      const token = doc.data().fcm_token;
      try {
        await admin.messaging().send({
          token,
          notification: { title: "SAGMA — Massoterapia", body: mensagemSelecionada },
          android: { priority: "normal" },
          apns: { payload: { aps: { sound: "default" } } },
        });
        enviados++;
      } catch (err) {
        erros++;
        logger.warn(`Falha ao enviar mensagem aleatória para ${doc.id}: ${err.message}`);
      }
    }

    logger.info(`dispararMensagensAleatorias: ${enviados} enviados, ${erros} erros.`);
    return { dryRun: false, enviados, erros, total: alvos.length, mensagem: mensagemSelecionada };
  }
);
