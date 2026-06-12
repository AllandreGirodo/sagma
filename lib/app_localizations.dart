import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:agenda/core/utils/app_strings.dart';

class AppLocalizations {
  final Locale locale;
  static AppLocalizations? _current;

  AppLocalizations(this.locale) {
    _current = this;
  }

  static AppLocalizations get current => _current ?? AppLocalizations(const Locale('pt', 'BR'));

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  String translate(String key, [Map<String, String>? params]) {
    String text = _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['pt']?[key] ??
        key;
    
    if (params != null) {
      params.forEach((k, v) {
        text = text.replaceAll('{$k}', v);
      });
    }
    return text;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const Map<String, Map<String, String>> _localizedValues = {
    'pt': {
      'appTitle': 'Agenda Massoterapia',
      'loginTitle': 'Agenda Massoterapia',
      'emailLabel': 'Email',
      'passwordLabel': 'Senha',
      'enterButton': 'ENTRAR',
      'createAccountButton': 'Criar conta',
      'fillFieldsError': 'Por favor, preencha email e senha',
      'loginSuccess': 'Login realizado com sucesso (Simulação)',
      'forgotPasswordButton': 'Esqueci minha senha',
      'aboutAppTitle': 'Sobre o Aplicativo',
    'softwareVersion': 'Versão do software: ${AppStrings.appVersion}',
    'lastUpdate': 'Última alteração: ${AppStrings.appLastUpdate}',
      'closeButton': 'Fechar',
            // Services Health Check
            'servicesCheckTitle': 'Verificação de Serviços',
            'servicesResultsTitle': 'Resultados',
            'servicesRunning': 'Executando...',
            'servicesRerun': 'Reexecutar checagens',
            'servicesOpenWhatsApp': 'Abrir WhatsApp',
            'servicesOpenWhatsAppHint': 'Abra em nova aba: https://web.whatsapp.com/',
            'serviceWhatsappWeb': 'WhatsApp Web (site)',
            'serviceFirestore': 'Cloud Firestore',
            'serviceAuth': 'Authentication',
            'serviceAppCheck': 'App Check (reCAPTCHA)',
            'serviceStorage': 'Firebase Storage',
            'serviceSql': 'SQL Connect',
            'serviceFunctions': 'Cloud Functions',
            'serviceStatusPending': 'Pendente',
            'serviceStatusChecking': 'Verificando...',
            'serviceStatusOk': 'OK',
            'serviceStatusFail': 'Falha',
            'serviceStatusUnverified': 'Não verificado',
            'serviceStatusNotApplicable': 'Não aplicável',
            'serviceStatusTokenEmpty': 'token vazio',
            'serviceStatusDocumentNotFound': 'documento não encontrado',
            'serviceStatusProgress': '{done} / {total}',
            'serviceStatusHttp': 'HTTP {code}',
            'servicesSectionSuccess': 'Serviços OK',
            'servicesSectionFail': 'Serviços com falha',
            'servicesSectionPending': 'Pendentes / em execução',
            'servicesSectionUnverified': 'Não verificados',
            'servicesNoItems': 'Nenhum item por enquanto',
            'servicesWhatsappLink': 'Link WhatsApp Web',
            'serviceFirestoreStructure': 'Estrutura do Banco',
            'serviceStructureDialogTitle': 'Criar Estrutura do Banco',
            'serviceStructureDialogContent': 'Serão criados {count} documento(s) faltando com valores padrão. Confirme com a senha admin.',
            'serviceStructurePasswordLabel': 'Senha Admin (DB_ADMIN_PASSWORD)',
            'serviceStructureCreateBtn': 'Criar',
            'serviceStructureWrongPassword': 'Senha incorreta.',
            'serviceStructureCreating': 'Criando documentos...',
            'serviceStructureDocsCount': '{done}/{total} documentos',
            'serviceStructureMissing': '{count} faltando: {labels}',
            'serviceStructureDocsCreated': '{done}/{total} documentos criados',
            'serviceStructureSuccess': 'Estrutura criada com sucesso!',
            'serviceStructureDbMissing': 'Banco não criado. Acesse Firebase Console → Firestore → Criar banco (default).',
      // Cadastro
      'signupTitle': 'Criar Conta',
      'fullNameLabel': 'Nome Completo',
      'whatsappLabel': 'WhatsApp',
      'phoneNumberLabel': 'Telefone/Celular',
    'isWhatsappNumber': 'Este número é WhatsApp',
    'isNotWhatsappNumber': 'Este número não é WhatsApp',
      'signupInvalidEmailTyping': 'E-mail ainda não é válido.',
      'signupPhoneOnlyDigitsMessage': 'Preencha apenas com números de 0 a 9.',
      'signupPhoneMinDigitsMessage': 'Mínimo de 10 dígitos necessários.',
      'signupPhoneDigitsLimitReached': 'Limite de dígitos do celular atingido.',
      'signupPasswordCriteriaTitle': 'Senha sugerida:',
      'signupPasswordRuleLength': 'Entre 6 e 20 caracteres',
      'signupPasswordRuleUppercase': 'Pelo menos 1 letra maiúscula',
      'signupPasswordRuleLowercase': 'Pelo menos 1 letra minúscula',
      'signupPasswordRuleNumber': 'Pelo menos 1 número',
      'signupPasswordRuleSpecial': 'Pelo menos 1 caractere especial',
      'signupPasswordWeakMessage':
          'A senha ainda não atende ao padrão sugerido.',
      'signupPasswordReadyMessage': 'Senha válida. Você já pode se cadastrar.',
      'signupNameRequiredMessage': 'Informe seu nome completo.',
      'signupPhoneMinDigitsSubmitMessage': '{label} com no mínimo 10 dígitos.',
      'signupLgpdConsentLabel':
          'Li e aceito os Termos de Uso e Política de Privacidade.',
      'signupLgpdConsentPendingMessage':
          'Aceite os Termos de Uso e Política de Privacidade para continuar.',
      'signupLgpdConsentAcceptedMessage':
          'Termos aceitos. Você já pode concluir o cadastro.',
      'signupLgpdConsentError':
          'É obrigatório ler e aceitar os Termos de Uso e Política de Privacidade para continuar.',
      'signupTermsReadButton': 'Ler Termos de Uso e Política de Privacidade',
      'signupGooglePrefilledEmailHint':
          'Complete os campos obrigatórios para concluir o vínculo deste e-mail.',
      'signupLinkedClientId': 'vinculo_id_cliente: {id}',
      'signupExistingClientLinkedMessage':
          'Já existe um cadastro completo para este e-mail. vinculo_id_cliente: {id}',
      'signupGoogleCompleteButton': 'CONCLUIR CADASTRO',
      'signupPendingRequiredFields':
          'Campos obrigatórios pendentes: {fields}',
      'registerButton': 'CADASTRAR',
      'registrationError': 'Erro ao cadastrar',
      // Agendamento
      'appointmentsTitle': 'Agendamentos',
      'newAppointmentTitle': 'Novo Agendamento',
      'dateLabel': 'Data',
      'selectTimeHint': 'Selecione um horário',
      'massageTypeRelaxante': 'Massagem Relaxante',
      'massageTypeDrenagemLinfatica': 'Drenagem Linfática',
      'massageTypeTerapeutica': 'Massagem Terapêutica',
      'massageTypeDesportiva': 'Massagem Desportiva',
      'massageTypePedrasQuentes': 'Massagem com Pedras Quentes',
      'cancelButton': 'Cancelar',
      'scheduleButton': 'Agendar',
      'appointmentSuccess': 'Agendamento realizado com sucesso!',
      'noAppointmentsFound': 'Nenhum agendamento encontrado.',
      'viewingAll': 'Vendo Todos',
      'viewingMine': 'Vendo Meus',
      'myProfileTooltip': 'Meu Perfil',
      'logoutTooltip': 'Sair',
      // Perfil
      'profileTitle': 'Meu Perfil',
      'dataTab': 'Dados',
      'historyTab': 'Histórico',
      'personalDataTitle': 'Dados Pessoais',
      'cpfLabel': 'CPF',
      'cepLabel': 'CEP',
      'addressLabel': 'Endereço',
      'birthDateLabel': 'Data de Nascimento',
      'anamnesisTitle': 'Ficha de Anamnese',
      'medicalHistoryLabel': 'Histórico Médico',
      'allergiesLabel': 'Alergias',
      'medicationsLabel': 'Medicamentos em uso',
      'surgeriesLabel': 'Cirurgias Recentes',
      'deleteAccountButton': 'Excluir minha conta e dados (LGPD)',
      'saveButton': 'Salvar',
      'requiredField': 'Este campo é obrigatório',
      // Aguardando Aprovação
      'waitingApprovalTitle': 'Aguardando Aprovação',
      'analysisTitle': 'Cadastro em Análise',
      'analysisMessage':
          'Seu cadastro realizado em\n{date}\nestá aguardando aprovação da administradora.',
      'contactAdminButton': 'Falar com a Administradora',
      'contactAdminButtonWithName': 'Falar com {adminName}',
      'backToLoginButton': 'Voltar para Login',
      // Unificacao Dinamica Global
      'loginSubtitle': 'Faça login para agendar sua sessão',
      'rememberCredentials': 'Lembrar minhas credenciais',
      'fillEmailPassword': 'Preencha e-mail e senha para continuar.',
      'invalidEmail': 'Digite um e-mail válido para entrar.',
      'passwordMinLength': 'A senha precisa ter pelo menos 6 caracteres.',
      'googleLoginError': 'Erro no Google Login: {error}',
      'searchByType': 'Buscar por tipo...',
      'noAvailableTimes': 'Não há horários disponíveis para esta data.',
      'selectMassageType': 'Selecione um tipo de massagem.',
      'selectTime': 'Selecione um horário.',
      'discountCoupon': 'Cupom de Desconto',
      'couponApplied': 'Cupom aplicado!',
      'invalidCoupon': 'Cupom inválido ou expirado.',
      'totalAmount': 'Total: {value}',
      'discountAmount': 'Desconto: {value}',
      'favorites': 'Favoritos:',
      'addFavorite': 'Adicionar aos favoritos',
      'removeFavorite': 'Remover dos favoritos',
      'appointmentDetails': 'Detalhes do Agendamento',
      'cancelAppointment': 'Cancelar Agendamento',
      'lateCancellation': 'Cancelamento Tardio',
      'informCancelReason': 'Por favor, informe o motivo do cancelamento:',
      'cancelReasonExample': 'Ex: Imprevisto de saúde',
      'confirmCancel': 'Confirmar Cancelamento',
      'adminTitle': 'Administração',
      'dashTab': 'Dash',
      'agendaTab': 'Agenda',
      'clientsTab': 'Clientes',
      'pendingTab': 'Pendentes',
      'appointmentsDay': 'Agendamentos (Dia)',
      'estRevenueMonth': 'Receita Est. (Mês)',
      'dailyStatus': 'Status do Dia',
      'cancelRate': 'Taxa de Cancelamento',
      'today': 'Hoje',
      'week': 'Semana',
      'month': 'Mês',
      'topTypes': 'Tipos Mais Agendados (Mês)',
      'noChartData': 'Sem dados para gráfico.',
      'devEnableMetrics': 'Dev: Ativar Gravação de Histórico',
      'allowSaveMetrics': 'Permite salvar as métricas de hoje no banco de dados.',
      'saveSnapshot': 'Gravar Snapshot do Dia',
      'metricsSaved': 'Métricas do dia salvas com sucesso!',
      'metricsSaveError': 'Erro ao salvar métricas: {error}',
      'noPendingAppointments': 'Nenhum agendamento pendente.',
      'approve': 'Aprovar',
      'reject': 'Recusar',
      'searchClient': 'Pesquisar Cliente',
      'noClientFound': 'Nenhum cliente encontrado.',
      'allowAllTimes': 'Permitir ver todos os horários',
      'changeUserTheme': 'Alterar Tema do Usuário',
      'changePackages': 'Alterar Pacotes',
      'noPendingUsers': 'Nenhum usuário pendente.',
      'approveRegistration': 'Aprovar Cadastro',
      'appointmentStatusSuccess': 'Agendamento {status} com sucesso!',
      'userApprovedSuccess': 'Usuário {name} aprovado com sucesso!',
      'waitlistLabel': 'Espera: {amount}',
      'genericError': 'Erro: {error}',
      'backButton': 'Voltar',
      'sendButton': 'Enviar',
      'confirmButton': 'Confirmar',
      'yes': 'Sim',
      'no': 'Não',
    },
    'en': {
      'appTitle': 'Massage Therapy Agenda',
      'loginTitle': 'Massage Therapy Agenda',
      'emailLabel': 'Email',
      'passwordLabel': 'Password',
      'enterButton': 'ENTER',
      'createAccountButton': 'Create account',
      'fillFieldsError': 'Please fill in email and password',
      'loginSuccess': 'Login successful (Simulation)',
      'forgotPasswordButton': 'Forgot password?',
      'aboutAppTitle': 'About the App',
    'softwareVersion': 'Software version: ${AppStrings.appVersion}',
    'lastUpdate': 'Last update: ${AppStrings.appLastUpdate}',
      'closeButton': 'Close',
            // Services Health Check
            'servicesCheckTitle': 'Services Check',
            'servicesResultsTitle': 'Results',
            'servicesRunning': 'Running...',
            'servicesRerun': 'Run checks again',
            'servicesOpenWhatsApp': 'Open WhatsApp',
            'servicesOpenWhatsAppHint': 'Open in a new tab: https://web.whatsapp.com/',
            'serviceWhatsappWeb': 'WhatsApp Web (site)',
            'serviceFirestore': 'Cloud Firestore',
            'serviceAuth': 'Authentication',
            'serviceAppCheck': 'App Check (reCAPTCHA)',
            'serviceStorage': 'Firebase Storage',
            'serviceSql': 'SQL Connect',
            'serviceFunctions': 'Cloud Functions',
            'serviceStatusPending': 'Pending',
            'serviceStatusChecking': 'Checking...',
            'serviceStatusOk': 'OK',
            'serviceStatusFail': 'Failed',
            'serviceStatusUnverified': 'Unverified',
            'serviceStatusNotApplicable': 'Not applicable',
            'serviceStatusTokenEmpty': 'empty token',
            'serviceStatusDocumentNotFound': 'document not found',
            'serviceStatusProgress': '{done} / {total}',
            'serviceStatusHttp': 'HTTP {code}',
            'servicesSectionSuccess': 'Healthy services',
            'servicesSectionFail': 'Failed services',
            'servicesSectionPending': 'Pending / running',
            'servicesSectionUnverified': 'Unverified',
            'servicesNoItems': 'No items yet',
            'servicesWhatsappLink': 'WhatsApp Web link',
            'serviceFirestoreStructure': 'Database Structure',
            'serviceStructureDialogTitle': 'Create Database Structure',
            'serviceStructureDialogContent': '{count} missing document(s) will be created with default values. Confirm with admin password.',
            'serviceStructurePasswordLabel': 'Admin Password (DB_ADMIN_PASSWORD)',
            'serviceStructureCreateBtn': 'Create',
            'serviceStructureWrongPassword': 'Wrong password.',
            'serviceStructureCreating': 'Creating documents...',
            'serviceStructureDocsCount': '{done}/{total} documents',
            'serviceStructureMissing': '{count} missing: {labels}',
            'serviceStructureDocsCreated': '{done}/{total} documents created',
            'serviceStructureSuccess': 'Structure created successfully!',
            'serviceStructureDbMissing': 'Database not created. Go to Firebase Console → Firestore → Create database (default).',
      // Signup
      'signupTitle': 'Create Account',
      'fullNameLabel': 'Full Name',
      'whatsappLabel': 'WhatsApp',
      'phoneNumberLabel': 'Phone Number',
    'isWhatsappNumber': 'WhatsApp number',
    'isNotWhatsappNumber': 'Not WhatsApp',
      'signupInvalidEmailTyping': 'Email is not valid yet.',
      'signupPhoneOnlyDigitsMessage': 'Use only numbers from 0 to 9.',
      'signupPhoneMinDigitsMessage': 'Minimum of 10 digits required.',
      'signupPhoneDigitsLimitReached': 'Phone digit limit reached.',
      'signupPasswordCriteriaTitle': 'Suggested password:',
      'signupPasswordRuleLength': 'Between 6 and 20 characters',
      'signupPasswordRuleUppercase': 'At least 1 uppercase letter',
      'signupPasswordRuleLowercase': 'At least 1 lowercase letter',
      'signupPasswordRuleNumber': 'At least 1 number',
      'signupPasswordRuleSpecial': 'At least 1 special character',
      'signupPasswordWeakMessage':
          'Password does not meet the suggested pattern yet.',
      'signupPasswordReadyMessage':
          'Password looks good. You can register now.',
      'signupNameRequiredMessage': 'Please enter your full name.',
      'signupPhoneMinDigitsSubmitMessage': '{label} with at least 10 digits.',
      'signupLgpdConsentLabel':
          'I have read and agree to the Terms of Use and Privacy Policy.',
      'signupLgpdConsentPendingMessage':
          'Please accept the Terms of Use and Privacy Policy to continue.',
      'signupLgpdConsentAcceptedMessage':
          'Terms accepted. You can complete your registration.',
      'signupLgpdConsentError':
          'You must read and accept the Terms of Use and Privacy Policy to continue.',
      'signupTermsReadButton': 'Read Terms of Use and Privacy Policy',
      'registerButton': 'REGISTER',
      'registrationError': 'Error registering',
      // Appointment
      'appointmentsTitle': 'Appointments',
      'newAppointmentTitle': 'New Appointment',
      'dateLabel': 'Date',
      'selectTimeHint': 'Select a time',
      'massageTypeRelaxante': 'Relaxing Massage',
      'massageTypeDrenagemLinfatica': 'Lymphatic Drainage',
      'massageTypeTerapeutica': 'Therapeutic Massage',
      'massageTypeDesportiva': 'Sports Massage',
      'massageTypePedrasQuentes': 'Hot Stone Massage',
      'cancelButton': 'Cancel',
      'scheduleButton': 'Schedule',
      'appointmentSuccess': 'Appointment scheduled successfully!',
      'noAppointmentsFound': 'No appointments found.',
      'viewingAll': 'Viewing All',
      'viewingMine': 'Viewing Mine',
      'myProfileTooltip': 'My Profile',
      'logoutTooltip': 'Logout',
      // Profile
      'profileTitle': 'My Profile',
      'dataTab': 'Data',
      'historyTab': 'History',
      'personalDataTitle': 'Personal Data',
      'cpfLabel': 'SSN/CPF',
      'cepLabel': 'Zip Code',
      'addressLabel': 'Address',
      'birthDateLabel': 'Birth Date',
      'anamnesisTitle': 'Anamnesis Form',
      'medicalHistoryLabel': 'Medical History',
      'allergiesLabel': 'Allergies',
      'medicationsLabel': 'Medications in use',
      'surgeriesLabel': 'Recent Surgeries',
      'deleteAccountButton': 'Delete my account and data (GDPR)',
      'saveButton': 'Save',
      'requiredField': 'This field is required',
      // Waiting Approval
      'waitingApprovalTitle': 'Waiting Approval',
      'analysisTitle': 'Registration Under Review',
      'analysisMessage':
          'Your registration made on\n{date}\nis awaiting administrator approval.',
      'contactAdminButton': 'Contact Administrator',
      'contactAdminButtonWithName': 'Contact {adminName}',
      'backToLoginButton': 'Back to Login',
      // Dynamic Unified
      'loginSubtitle': 'Sign in to schedule your session',
      'rememberCredentials': 'Remember my credentials',
      'fillEmailPassword': 'Enter email and password to continue.',
      'invalidEmail': 'Enter a valid email to sign in.',
      'passwordMinLength': 'Password must have at least 6 characters.',
      'googleLoginError': 'Google Login error: {error}',
      'searchByType': 'Search by type...',
      'noAvailableTimes': 'There are no available time slots for this date.',
      'selectMassageType': 'Please select a massage type.',
      'selectTime': 'Please select a time slot.',
      'discountCoupon': 'Discount Coupon',
      'couponApplied': 'Coupon applied!',
      'invalidCoupon': 'Invalid or expired coupon.',
      'totalAmount': 'Total: {value}',
      'discountAmount': 'Discount: {value}',
      'favorites': 'Favorites:',
      'addFavorite': 'Add to favorites',
      'removeFavorite': 'Remove from favorites',
      'appointmentDetails': 'Appointment Details',
      'cancelAppointment': 'Cancel Appointment',
      'lateCancellation': 'Late Cancellation',
      'informCancelReason': 'Please inform the reason for cancellation:',
      'cancelReasonExample': 'E.g.: Health emergency',
      'confirmCancel': 'Confirm Cancellation',
      'adminTitle': 'Administration',
      'dashTab': 'Dash',
      'agendaTab': 'Schedule',
      'clientsTab': 'Clients',
      'pendingTab': 'Pending',
      'appointmentsDay': 'Appointments (Day)',
      'estRevenueMonth': 'Est. Revenue (Month)',
      'dailyStatus': 'Daily Status',
      'cancelRate': 'Cancellation Rate',
      'today': 'Today',
      'week': 'Week',
      'month': 'Month',
      'topTypes': 'Most Scheduled Types (Month)',
      'noChartData': 'No data for chart.',
      'devEnableMetrics': 'Dev: Enable History Logging',
      'allowSaveMetrics': 'Allows saving today\'s metrics to the database.',
      'saveSnapshot': 'Save Daily Snapshot',
      'metricsSaved': 'Daily metrics saved successfully!',
      'metricsSaveError': 'Error saving metrics: {error}',
      'noPendingAppointments': 'No pending appointments.',
      'approve': 'Approve',
      'reject': 'Reject',
      'searchClient': 'Search Client',
      'noClientFound': 'No clients found.',
      'allowAllTimes': 'Allow viewing all times',
      'changeUserTheme': 'Change User Theme',
      'changePackages': 'Change Packages',
      'noPendingUsers': 'No pending users.',
      'approveRegistration': 'Approve Registration',
      'appointmentStatusSuccess': 'Appointment {status} successfully!',
      'userApprovedSuccess': 'User {name} approved successfully!',
      'waitlistLabel': 'Waitlist: {amount}',
      'genericError': 'Error: {error}',
      'backButton': 'Back',
      'sendButton': 'Send',
      'confirmButton': 'Confirm',
      'yes': 'Yes',
      'no': 'No',
    },
    'es': {
      'appTitle': 'Agenda de Masoterapia',
      'loginTitle': 'Agenda de Masoterapia',
      'emailLabel': 'Correo electrónico',
      'passwordLabel': 'Contraseña',
      'enterButton': 'ENTRAR',
      'createAccountButton': 'Crear cuenta',
      'fillFieldsError': 'Por favor complete correo y contraseña',
      'loginSuccess': 'Inicio de sesión exitoso (Simulación)',
      'forgotPasswordButton': '¿Olvidó su contraseña?',
      'aboutAppTitle': 'Sobre la Aplicación',
    'softwareVersion': 'Versión del software: ${AppStrings.appVersion}',
    'lastUpdate': 'Última actualización: ${AppStrings.appLastUpdate}',
      'closeButton': 'Cerrar',
      // Services Health Check
      'servicesCheckTitle': 'Verificación de Servicios',
      'servicesResultsTitle': 'Resultados',
      'servicesRunning': 'Ejecutando...',
      'servicesRerun': 'Reejecutar verificaciones',
      'servicesOpenWhatsApp': 'Abrir WhatsApp',
      'servicesOpenWhatsAppHint': 'Abrir en nueva pestaña: https://web.whatsapp.com/',
      'serviceWhatsappWeb': 'WhatsApp Web (sitio)',
      'serviceFirestore': 'Cloud Firestore',
      'serviceAuth': 'Authentication',
      'serviceAppCheck': 'App Check (reCAPTCHA)',
      'serviceStorage': 'Firebase Storage',
      'serviceSql': 'SQL Connect',
      'serviceFunctions': 'Cloud Functions',
      'serviceStatusPending': 'Pendiente',
      'serviceStatusChecking': 'Verificando...',
      'serviceStatusOk': 'OK',
      'serviceStatusFail': 'Fallo',
      'serviceStatusUnverified': 'No verificado',
      'serviceStatusNotApplicable': 'No aplicable',
      'serviceStatusTokenEmpty': 'token vacío',
      'serviceStatusDocumentNotFound': 'documento no encontrado',
      'serviceStatusProgress': '{done} / {total}',
      'serviceStatusHttp': 'HTTP {code}',
      'servicesSectionSuccess': 'Servicios OK',
      'servicesSectionFail': 'Servicios con fallo',
      'servicesSectionPending': 'Pendientes / en ejecución',
      'servicesSectionUnverified': 'No verificados',
      'servicesNoItems': 'Ningún elemento por ahora',
      'servicesWhatsappLink': 'Enlace WhatsApp Web',
      'serviceFirestoreStructure': 'Estructura de la Base de Datos',
      'serviceStructureDialogTitle': 'Crear Estructura de la Base de Datos',
      'serviceStructureDialogContent': 'Se crearán {count} documento(s) faltante(s) con valores predeterminados. Confirme con la contraseña de administrador.',
      'serviceStructurePasswordLabel': 'Contraseña Admin (DB_ADMIN_PASSWORD)',
      'serviceStructureCreateBtn': 'Crear',
      'serviceStructureWrongPassword': 'Contraseña incorrecta.',
      'serviceStructureCreating': 'Creando documentos...',
      'serviceStructureDocsCount': '{done}/{total} documentos',
      'serviceStructureMissing': '{count} faltante(s): {labels}',
      'serviceStructureDocsCreated': '{done}/{total} documentos creados',
      'serviceStructureSuccess': '¡Estructura creada con éxito!',
      'serviceStructureDbMissing': 'Base de datos no creada. Vaya a Firebase Console → Firestore → Crear base de datos (default).',
      // Signup
      'signupTitle': 'Crear Cuenta',
      'fullNameLabel': 'Nombre Completo',
      'whatsappLabel': 'WhatsApp',
      'phoneNumberLabel': 'Número de teléfono',
    'isWhatsappNumber': 'Es WhatsApp',
    'isNotWhatsappNumber': 'No es WhatsApp',
      'signupInvalidEmailTyping': 'El correo aún no es válido.',
      'signupPhoneOnlyDigitsMessage': 'Complete solo con números del 0 al 9.',
      'signupPhoneMinDigitsMessage': 'Se requieren mínimo 10 dígitos.',
      'signupPhoneDigitsLimitReached':
          'Se alcanzó el límite de dígitos del celular.',
      'signupPasswordCriteriaTitle': 'Contraseña sugerida:',
      'signupPasswordRuleLength': 'Entre 6 y 20 caracteres',
      'signupPasswordRuleUppercase': 'Al menos 1 letra mayúscula',
      'signupPasswordRuleLowercase': 'Al menos 1 letra minúscula',
      'signupPasswordRuleNumber': 'Al menos 1 número',
      'signupPasswordRuleSpecial': 'Al menos 1 carácter especial',
      'signupPasswordWeakMessage':
          'La contraseña aún no cumple el patrón sugerido.',
      'signupPasswordReadyMessage': 'Contraseña válida. Ya puede registrarse.',
      'signupNameRequiredMessage': 'Informe su nombre completo.',
      'signupPhoneMinDigitsSubmitMessage': '{label} con al menos 10 dígitos.',
      'signupLgpdConsentLabel':
          'He leído y acepto los Términos de Uso y la Política de Privacidad.',
      'signupLgpdConsentPendingMessage':
          'Acepte los Términos de Uso y la Política de Privacidad para continuar.',
      'signupLgpdConsentAcceptedMessage':
          'Términos aceptados. Ya puede completar su registro.',
      'signupLgpdConsentError':
          'Debe leer y aceptar los Términos de Uso y la Política de Privacidad para continuar.',
      'signupTermsReadButton': 'Leer Términos de Uso y Política de Privacidad',
      'registerButton': 'REGISTRAR',
      'registrationError': 'Error al registrar',
      // Appointment
      'appointmentsTitle': 'Citas',
      'newAppointmentTitle': 'Nueva Cita',
      'dateLabel': 'Fecha',
      'selectTimeHint': 'Seleccione una hora',
      'massageTypeRelaxante': 'Masaje Relajante',
      'massageTypeDrenagemLinfatica': 'Drenaje Linfático',
      'massageTypeTerapeutica': 'Masaje Terapéutico',
      'massageTypeDesportiva': 'Masaje Deportivo',
      'massageTypePedrasQuentes': 'Masaje con Piedras Calientes',
      'cancelButton': 'Cancelar',
      'scheduleButton': 'Agendar',
      'appointmentSuccess': '¡Cita programada con éxito!',
      'noAppointmentsFound': 'No se encontraron citas.',
      'viewingAll': 'Viendo Todos',
      'viewingMine': 'Viendo Míos',
      'myProfileTooltip': 'Mi Perfil',
      'logoutTooltip': 'Salir',
      // Profile
      'profileTitle': 'Mi Perfil',
      'dataTab': 'Datos',
      'historyTab': 'Historial',
      'personalDataTitle': 'Datos Personales',
      'cpfLabel': 'CPF/DNI',
      'cepLabel': 'Código Postal',
      'addressLabel': 'Dirección',
      'birthDateLabel': 'Fecha de Nacimiento',
      'anamnesisTitle': 'Ficha de Anamnesis',
      'medicalHistoryLabel': 'Historial Médico',
      'allergiesLabel': 'Alergias',
      'medicationsLabel': 'Medicamentos en uso',
      'surgeriesLabel': 'Cirugías Recientes',
      'deleteAccountButton': 'Eliminar mi cuenta y datos',
      'saveButton': 'Guardar',
      'requiredField': 'Este campo es obligatorio',
      // Waiting Approval
      'waitingApprovalTitle': 'Esperando Aprobación',
      'analysisTitle': 'Registro en Revisión',
      'analysisMessage':
          'Su registro realizado el\n{date}\nestá esperando aprobación del administrador.',
      'contactAdminButton': 'Contactar Administrador',
      'contactAdminButtonWithName': 'Contactar a {adminName}',
      'backToLoginButton': 'Volver al Login',
      // Dynamic Unified
      'loginSubtitle': 'Inicie sesión para programar su cita',
      'rememberCredentials': 'Recordar mis credenciales',
      'fillEmailPassword': 'Ingrese correo y contraseña para continuar.',
      'invalidEmail': 'Ingrese un correo válido.',
      'passwordMinLength': 'La contraseña debe tener al menos 6 caracteres.',
      'googleLoginError': 'Error en Google Login: {error}',
      'searchByType': 'Buscar por tipo...',
      'noAvailableTimes': 'No hay horarios disponibles para esta fecha.',
      'selectMassageType': 'Por favor seleccione un tipo de masaje.',
      'selectTime': 'Seleccione un horario.',
      'discountCoupon': 'Cupón de Descuento',
      'couponApplied': '¡Cupón aplicado!',
      'invalidCoupon': 'Cupón inválido o caducado.',
      'totalAmount': 'Total: {value}',
      'discountAmount': 'Descuento: {value}',
      'favorites': 'Favoritos:',
      'addFavorite': 'Añadir a favoritos',
      'removeFavorite': 'Quitar de favoritos',
      'appointmentDetails': 'Detalles de la Cita',
      'cancelAppointment': 'Cancelar Cita',
      'lateCancellation': 'Cancelación Tardía',
      'informCancelReason': 'Por favor, informe el motivo de la cancelación:',
      'cancelReasonExample': 'Ej: Emergencia de salud',
      'confirmCancel': 'Confirmar Cancelación',
      'adminTitle': 'Administración',
      'dashTab': 'Panel',
      'agendaTab': 'Agenda',
      'clientsTab': 'Clientes',
      'pendingTab': 'Pendientes',
      'appointmentsDay': 'Citas (Día)',
      'estRevenueMonth': 'Ingreso Est. (Mes)',
      'dailyStatus': 'Estado del Día',
      'cancelRate': 'Tasa de Cancelación',
      'today': 'Hoy',
      'week': 'Semana',
      'month': 'Mes',
      'topTypes': 'Tipos Más Agendados (Mes)',
      'noChartData': 'Sin datos para el gráfico.',
      'devEnableMetrics': 'Dev: Activar Registro de Historial',
      'allowSaveMetrics': 'Permite guardar las métricas de hoy en la base de datos.',
      'saveSnapshot': 'Guardar Snapshot del Día',
      'metricsSaved': '¡Métricas del día guardadas con éxito!',
      'metricsSaveError': 'Error al guardar métricas: {error}',
      'noPendingAppointments': 'No hay citas pendientes.',
      'approve': 'Aprobar',
      'reject': 'Rechazar',
      'searchClient': 'Buscar Cliente',
      'noClientFound': 'No se encontraron clientes.',
      'allowAllTimes': 'Permitir ver todos los horarios',
      'changeUserTheme': 'Cambiar Tema de Usuario',
      'changePackages': 'Cambiar Paquetes',
      'noPendingUsers': 'No hay usuarios pendientes.',
      'approveRegistration': 'Aprobar Registro',
      'appointmentStatusSuccess': '¡Cita {status} con éxito!',
      'userApprovedSuccess': '¡Usuario {name} aprobado con éxito!',
      'waitlistLabel': 'Espera: {amount}',
      'genericError': 'Error: {error}',
      'backButton': 'Volver',
      'sendButton': 'Enviar',
      'confirmButton': 'Confirmar',
      'yes': 'Sí',
      'no': 'No',
    },
    'ja': {
      'appTitle': 'マッサージ予約',
      'loginTitle': 'マッサージ予約',
      'emailLabel': 'メールアドレス',
      'passwordLabel': 'パスワード',
      'enterButton': 'ログイン',
      'createAccountButton': 'アカウント作成',
      'fillFieldsError': 'メールとパスワードを入力してください',
      'loginSuccess': 'ログイン成功（シミュレーション）',
      'forgotPasswordButton': 'パスワードを忘れた場合',
      'aboutAppTitle': 'アプリについて',
    'softwareVersion': 'ソフトウェアバージョン: ${AppStrings.appVersion}',
    'lastUpdate': '最終更新日: ${AppStrings.appLastUpdate}',
      'closeButton': '閉じる',
      // Services Health Check
      'servicesCheckTitle': 'サービス確認',
      'servicesResultsTitle': '結果',
      'servicesRunning': '実行中...',
      'servicesRerun': '再確認',
      'servicesOpenWhatsApp': 'WhatsAppを開く',
      'servicesOpenWhatsAppHint': '新しいタブで開く: https://web.whatsapp.com/',
      'serviceWhatsappWeb': 'WhatsApp Web (サイト)',
      'serviceFirestore': 'Cloud Firestore',
      'serviceAuth': 'Authentication',
      'serviceAppCheck': 'App Check (reCAPTCHA)',
      'serviceStorage': 'Firebase Storage',
      'serviceSql': 'SQL Connect',
      'serviceFunctions': 'Cloud Functions',
      'serviceStatusPending': '保留中',
      'serviceStatusChecking': '確認中...',
      'serviceStatusOk': 'OK',
      'serviceStatusFail': '失敗',
      'serviceStatusUnverified': '未確認',
      'serviceStatusNotApplicable': '対象外',
      'serviceStatusTokenEmpty': 'トークンが空',
      'serviceStatusDocumentNotFound': 'ドキュメントが見つかりません',
      'serviceStatusProgress': '{done} / {total}',
      'serviceStatusHttp': 'HTTP {code}',
      'servicesSectionSuccess': '正常なサービス',
      'servicesSectionFail': '失敗したサービス',
      'servicesSectionPending': '保留中 / 実行中',
      'servicesSectionUnverified': '未確認',
      'servicesNoItems': 'アイテムがありません',
      'servicesWhatsappLink': 'WhatsApp Webリンク',
      'serviceFirestoreStructure': 'データベース構造',
      'serviceStructureDialogTitle': 'データベース構造を作成',
      'serviceStructureDialogContent': '{count}件の不足ドキュメントをデフォルト値で作成します。管理者パスワードで確認してください。',
      'serviceStructurePasswordLabel': '管理者パスワード (DB_ADMIN_PASSWORD)',
      'serviceStructureCreateBtn': '作成',
      'serviceStructureWrongPassword': 'パスワードが間違っています。',
      'serviceStructureCreating': 'ドキュメントを作成中...',
      'serviceStructureDocsCount': '{done}/{total} ドキュメント',
      'serviceStructureMissing': '{count}件不足: {labels}',
      'serviceStructureDocsCreated': '{done}/{total} ドキュメント作成済み',
      'serviceStructureSuccess': '構造が正常に作成されました！',
      'serviceStructureDbMissing': 'データベースが作成されていません。Firebase Console → Firestore → データベースを作成 (default) へ。',
      // Signup
      'signupTitle': 'アカウント作成',
      'fullNameLabel': '氏名',
      'whatsappLabel': 'WhatsApp',
      'phoneNumberLabel': '電話番号',
    'isWhatsappNumber': 'WhatsApp番号',
    'isNotWhatsappNumber': 'WhatsApp以外',
      'signupInvalidEmailTyping': 'メールアドレスの形式がまだ無効です。',
      'signupPhoneOnlyDigitsMessage': '0から9の数字のみ入力してください。',
      'signupPhoneMinDigitsMessage': '最低10桁が必要です。',
      'signupPhoneDigitsLimitReached': '電話番号の桁数上限に達しました。',
      'signupPasswordCriteriaTitle': '推奨パスワード:',
      'signupPasswordRuleLength': '6〜20文字',
      'signupPasswordRuleUppercase': '英大文字を1文字以上',
      'signupPasswordRuleLowercase': '英小文字を1文字以上',
      'signupPasswordRuleNumber': '数字を1文字以上',
      'signupPasswordRuleSpecial': '記号を1文字以上',
      'signupPasswordWeakMessage': 'パスワードが推奨パターンをまだ満たしていません。',
      'signupPasswordReadyMessage': 'パスワードは有効です。登録できます。',
      'signupNameRequiredMessage': '氏名を入力してください。',
      'signupPhoneMinDigitsSubmitMessage': '{label}は10桁以上で入力してください。',
      'signupLgpdConsentLabel': '利用規約とプライバシーポリシーを読み、同意します。',
      'signupLgpdConsentPendingMessage': '続行するには利用規約とプライバシーポリシーに同意してください。',
      'signupLgpdConsentAcceptedMessage': '利用規約への同意が完了しました。登録を完了できます。',
      'signupLgpdConsentError': '続行するには利用規約とプライバシーポリシーの確認と同意が必要です。',
      'signupTermsReadButton': '利用規約とプライバシーポリシーを読む',
      'registerButton': '登録',
      'registrationError': '登録エラー',
      // Appointment
      'appointmentsTitle': '予約',
      'newAppointmentTitle': '新規予約',
      'dateLabel': '日付',
      'selectTimeHint': '時間を選択',
      'massageTypeRelaxante': 'リラクゼーションマッサージ',
      'massageTypeDrenagemLinfatica': 'リンパドレナージュ',
      'massageTypeTerapeutica': 'セラピーマッサージ',
      'massageTypeDesportiva': 'スポーツマッサージ',
      'massageTypePedrasQuentes': 'ホットストーンマッサージ',
      'cancelButton': 'キャンセル',
      'scheduleButton': '予約する',
      'appointmentSuccess': '予約が完了しました！',
      'noAppointmentsFound': '予約が見つかりません。',
      'viewingAll': 'すべて表示',
      'viewingMine': '自分の予約',
      'myProfileTooltip': 'プロフィール',
      'logoutTooltip': 'ログアウト',
      // Profile
      'profileTitle': 'プロフィール',
      'dataTab': 'データ',
      'historyTab': '履歴',
      'personalDataTitle': '個人情報',
      'cpfLabel': 'CPF',
      'cepLabel': '郵便番号',
      'addressLabel': '住所',
      'birthDateLabel': '生年月日',
      'anamnesisTitle': '問診票',
      'medicalHistoryLabel': '病歴',
      'allergiesLabel': 'アレルギー',
      'medicationsLabel': '服用中の薬',
      'surgeriesLabel': '最近の手術',
      'deleteAccountButton': 'アカウントとデータを削除',
      'saveButton': '保存',
      'requiredField': '必須項目です',
      // Waiting Approval
      'waitingApprovalTitle': '承認待ち',
      'analysisTitle': '審査中',
      'analysisMessage': '{date} に行われた登録は\n管理者の承認待ちです。',
      'contactAdminButton': '管理者に連絡',
    'contactAdminButtonWithName': '{adminName} に連絡',
      'backToLoginButton': 'ログインに戻る',
      // Dynamic Unified
      'loginSubtitle': '予約するにはログインしてください',
      'rememberCredentials': '認証情報を記憶する',
      'fillEmailPassword': 'メールとパスワードを入力してください。',
      'invalidEmail': '有効なメールアドレスを入力してください。',
      'passwordMinLength': 'パスワードは6文字以上にする必要があります。',
      'googleLoginError': 'Googleログインエラー: {error}',
      'searchByType': '種類で検索...',
      'noAvailableTimes': 'この日付に利用可能な時間枠はありません。',
      'selectMassageType': 'マッサージの種類を選択してください。',
      'selectTime': '時間を選択してください。',
      'discountCoupon': '割引クーポン',
      'couponApplied': 'クーポンが適用されました！',
      'invalidCoupon': '無効または期限切れのクーポンです。',
      'totalAmount': '合計: {value}',
      'discountAmount': '割引: {value}',
      'favorites': 'お気に入り:',
      'addFavorite': 'お気に入りに追加',
      'removeFavorite': 'お気に入りから削除',
      'appointmentDetails': '予約の詳細',
      'cancelAppointment': '予約をキャンセル',
      'lateCancellation': '遅延キャンセル',
      'informCancelReason': 'キャンセルの理由をお知らせください:',
      'cancelReasonExample': '例: 健康上の緊急事態',
      'confirmCancel': 'キャンセルを確定',
      'adminTitle': '管理',
      'dashTab': 'ダッシュボード',
      'agendaTab': 'スケジュール',
      'clientsTab': 'クライアント',
      'pendingTab': '保留中',
      'appointmentsDay': '予約 (日)',
      'estRevenueMonth': '推定収益 (月)',
      'dailyStatus': '本日のステータス',
      'cancelRate': 'キャンセル率',
      'today': '今日',
      'week': '今週',
      'month': '今月',
      'topTypes': '最も予約された種類 (月)',
      'noChartData': 'グラフのデータがありません。',
      'devEnableMetrics': 'Dev: 履歴記録を有効にする',
      'allowSaveMetrics': '本日の指標を保存できるようにします。',
      'saveSnapshot': '本日のスナップショットを保存',
      'metricsSaved': '指標が正常に保存されました！',
      'metricsSaveError': '指標の保存エラー: {error}',
      'noPendingAppointments': '保留中の予約はありません。',
      'approve': '承認',
      'reject': '拒否',
      'searchClient': 'クライアントを検索',
      'noClientFound': 'クライアントが見つかりません。',
      'allowAllTimes': 'すべての時間枠の表示を許可',
      'changeUserTheme': 'ユーザーテーマを変更',
      'changePackages': 'パッケージを変更',
      'noPendingUsers': '保留中のユーザーはいません。',
      'approveRegistration': '登録を承認',
      'appointmentStatusSuccess': '予約が正常に {status} されました！',
      'userApprovedSuccess': 'ユーザー {name} が承認されました！',
      'waitlistLabel': 'キャンセル待ち: {amount}',
      'genericError': 'エラー: {error}',
      'backButton': '戻る',
      'sendButton': '送信',
      'confirmButton': '確認',
      'yes': 'はい',
      'no': 'いいえ',
    },
    'fr': {
      'appTitle': 'Agenda de massothérapie',
      'loginTitle': 'Agenda de massothérapie',
      'emailLabel': 'Email',
      'passwordLabel': 'Mot de passe',
      'enterButton': 'ENTRER',
      'createAccountButton': 'Créer un compte',
      'fillFieldsError': 'Veuillez remplir l\'email et le mot de passe',
      'loginSuccess': 'Connexion réussie (Simulation)',
      'forgotPasswordButton': 'Mot de passe oublié?',
      'aboutAppTitle': 'À propos de l\'application',
    'softwareVersion': 'Version du logiciel: ${AppStrings.appVersion}',
    'lastUpdate': 'Dernière mise à jour: ${AppStrings.appLastUpdate}',
      'closeButton': 'Fermer',
      // Signup
      'signupTitle': 'Créer un compte',
      'fullNameLabel': 'Nom complet',
      'whatsappLabel': 'WhatsApp',
      'phoneNumberLabel': 'Téléphone',
    'isWhatsappNumber': 'Numéro WhatsApp',
    'isNotWhatsappNumber': 'Pas WhatsApp',
      'signupInvalidEmailTyping': 'L\'email n\'est pas encore valide.',
      'signupPhoneOnlyDigitsMessage':
          'Complétez uniquement avec les chiffres de 0 à 9.',
      'signupPhoneMinDigitsMessage': 'Minimum de 10 chiffres requis.',
      'signupPhoneDigitsLimitReached':
          'Limite de chiffres du téléphone atteinte.',
      'signupPasswordCriteriaTitle': 'Mot de passe suggéré:',
      'signupPasswordRuleLength': 'Entre 6 et 20 caractères',
      'signupPasswordRuleUppercase': 'Au moins 1 lettre majuscule',
      'signupPasswordRuleLowercase': 'Au moins 1 lettre minuscule',
      'signupPasswordRuleNumber': 'Au moins 1 chiffre',
      'signupPasswordRuleSpecial': 'Au moins 1 caractère spécial',
      'signupPasswordWeakMessage':
          'Le mot de passe n\'a pas encore respecté le modèle suggéré.',
      'signupPasswordReadyMessage':
          'Mot de passe valide. Vous pouvez maintenant vous enregistrer.',
      'signupNameRequiredMessage': 'Veuillez saisir votre nom complet.',
      'signupPhoneMinDigitsSubmitMessage': '{label} avec au moins 10 chiffres.',
      'signupLgpdConsentLabel':
          'J\'ai lu et j\'accepte les conditions d\'utilisation et la politique de confidentialité.',
      'signupLgpdConsentPendingMessage':
          'Veuillez accepter les conditions d\'utilisation et la politique de confidentialité pour continuer.',
      'signupLgpdConsentAcceptedMessage':
          'Conditions acceptées. Vous pouvez finaliser votre inscription.',
      'signupLgpdConsentError':
          'Vous devez lire et accepter les conditions d\'utilisation et la politique de confidentialité pour continuer.',
      'signupTermsReadButton':
          'Lire les conditions d\'utilisation et la politique de confidentialité',
      'registerButton': 'ENREGISTRER',
      'registrationError': 'Erreur d\'enregistrement',
      // Appointment
      'appointmentsTitle': 'Rendez-vous',
      'newAppointmentTitle': 'Nouveau rendez-vous',
      'dateLabel': 'Date',
      'selectTimeHint': 'Sélectionnez une heure',
      'massageTypeRelaxante': 'Massage relaxant',
      'massageTypeDrenagemLinfatica': 'Drainage lymphatique',
      'massageTypeTerapeutica': 'Massage thérapeutique',
      'massageTypeDesportiva': 'Massage sportif',
      'massageTypePedrasQuentes': 'Massage aux pierres chaudes',
      'cancelButton': 'Annuler',
      'scheduleButton': 'Planifier',
      'appointmentSuccess': 'Rendez-vous programmé avec succès!',
      'noAppointmentsFound': 'Aucun rendez-vous trouvé.',
      'viewingAll': 'Affichage di tout',
      'viewingMine': 'Affichage des miens',
      'myProfileTooltip': 'Mon Profil',
      'logoutTooltip': 'Déconnexion',
      // Profile
      'profileTitle': 'Mon Profil',
      'dataTab': 'Données',
      'historyTab': 'Historique',
      'personalDataTitle': 'Données personnelles',
      'cpfLabel': 'CPF/Identifiant',
      'cepLabel': 'Code Postal',
      'addressLabel': 'Adresse',
      'birthDateLabel': 'Date de naissance',
      'anamnesisTitle': 'Formulaire d\'anamnèse',
      'medicalHistoryLabel': 'Historique médical',
      'allergiesLabel': 'Allergies',
      'medicationsLabel': 'Médicaments utilisés',
      'surgeriesLabel': 'Chirurgies récentes',
      'deleteAccountButton': 'Supprimer mon compte et mes données',
      'saveButton': 'Enregistrer',
      'requiredField': 'Ce champ est obligatoire',
      // Waiting Approval
      'waitingApprovalTitle': 'En attente d\'approbation',
      'analysisTitle': 'Enregistrement en révision',
      'analysisMessage':
          'Votre enregistrement effectué le\n{date}\nattend l\'approbation de l\'administrateur.',
      'contactAdminButton': 'Contacter l\'administrateur',
      'contactAdminButtonWithName': 'Contacter {adminName}',
      'backToLoginButton': 'Retour à la connexion',
      // Dynamic Unified
      'loginSubtitle': 'Connectez-vous pour planifier votre séance',
      'rememberCredentials': 'Se souvenir de mes identifiants',
      'fillEmailPassword': 'Entrez l\'e-mail et le mot de passe pour continuer.',
      'invalidEmail': 'Entrez un e-mail valide.',
      'passwordMinLength': 'Le mot de passe doit comporter au moins 6 caractères.',
      'googleLoginError': 'Erreur Google Login: {error}',
      'searchByType': 'Rechercher par type...',
      'noAvailableTimes': 'Aucun créneau disponible pour cette date.',
      'selectMassageType': 'Veuillez sélectionner un type de massage.',
      'selectTime': 'Veuillez sélectionner un créneau.',
      'discountCoupon': 'Code Promo',
      'couponApplied': 'Code promo appliqué!',
      'invalidCoupon': 'Code promo invalide ou expiré.',
      'totalAmount': 'Total: {value}',
      'discountAmount': 'Remise: {value}',
      'favorites': 'Favoris:',
      'addFavorite': 'Ajouter aux favoris',
      'removeFavorite': 'Retirer des favoris',
      'appointmentDetails': 'Détails du Rendez-vous',
      'cancelAppointment': 'Annuler le Rendez-vous',
      'lateCancellation': 'Annulation Tardive',
      'informCancelReason': 'Veuillez indiquer le motif de l\'annulation:',
      'cancelReasonExample': 'Ex: Urgence médicale',
      'confirmCancel': 'Confirmer l\'Annulation',
      'adminTitle': 'Administration',
      'dashTab': 'Tableau de bord',
      'agendaTab': 'Agenda',
      'clientsTab': 'Clients',
      'pendingTab': 'En attente',
      'appointmentsDay': 'Rendez-vous (Jour)',
      'estRevenueMonth': 'Revenus Est. (Mois)',
      'dailyStatus': 'Statut du Jour',
      'cancelRate': 'Taux d\'Annulation',
      'today': 'Aujourd\'hui',
      'week': 'Semaine',
      'month': 'Mois',
      'topTypes': 'Types les plus programmés (Mois)',
      'noChartData': 'Aucune donnée pour le graphique.',
      'devEnableMetrics': 'Dev: Activer l\'enregistrement',
      'allowSaveMetrics': 'Permet d\'enregistrer les métriques d\'aujourd\'hui.',
      'saveSnapshot': 'Enregistrer le snapshot',
      'metricsSaved': 'Métriques enregistrées avec succès!',
      'metricsSaveError': 'Erreur lors de l\'enregistrement: {error}',
      'noPendingAppointments': 'Aucun rendez-vous en attente.',
      'approve': 'Approuver',
      'reject': 'Rejeter',
      'searchClient': 'Rechercher un Client',
      'noClientFound': 'Aucun client trouvé.',
      'allowAllTimes': 'Permettre de voir tous les créneaux',
      'changeUserTheme': 'Changer le Thème',
      'changePackages': 'Changer les Forfaits',
      'noPendingUsers': 'Aucun utilisateur en attente.',
      'approveRegistration': 'Approuver l\'Inscription',
      'appointmentStatusSuccess': 'Rendez-vous {status} avec succès!',
      'userApprovedSuccess': 'Utilisateur {name} approuvé avec succès!',
      'waitlistLabel': 'Attente: {amount}',
      'genericError': 'Erreur: {error}',
      'backButton': 'Retour',
      'sendButton': 'Envoyer',
      'confirmButton': 'Confirmer',
      'yes': 'Oui',
      'no': 'Non',
    },
  };

  // Método auxiliar para buscar a tradução com fallback para PT
  String _t(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['pt']![key] ??
        key;
  }

  String get appTitle => _t('appTitle');
  String get loginTitle => _t('loginTitle');
  String get emailLabel => _t('emailLabel');
  String get passwordLabel => _t('passwordLabel');
  String get enterButton => _t('enterButton');
  String get createAccountButton => _t('createAccountButton');
  String get fillFieldsError => _t('fillFieldsError');
  String get loginSuccess => _t('loginSuccess');
  String get forgotPasswordButton => _t('forgotPasswordButton');
  String get aboutAppTitle => _t('aboutAppTitle');
  String get softwareVersion => _t('softwareVersion');
  String get lastUpdate => _t('lastUpdate');
  String get closeButton => _t('closeButton');
  String get servicesCheckTitle => _t('servicesCheckTitle');
  String get servicesResultsTitle => _t('servicesResultsTitle');
  String get servicesRunning => _t('servicesRunning');
  String get servicesRerun => _t('servicesRerun');
  String get servicesOpenWhatsApp => _t('servicesOpenWhatsApp');
  String get servicesOpenWhatsAppHint => _t('servicesOpenWhatsAppHint');
  String get serviceWhatsappWeb => _t('serviceWhatsappWeb');
  String get serviceFirestore => _t('serviceFirestore');
  String get serviceAuth => _t('serviceAuth');
  String get serviceAppCheck => _t('serviceAppCheck');
  String get serviceStorage => _t('serviceStorage');
  String get serviceSql => _t('serviceSql');
  String get serviceFunctions => _t('serviceFunctions');
  String get serviceStatusPending => _t('serviceStatusPending');
  String get serviceStatusChecking => _t('serviceStatusChecking');
  String get serviceStatusOk => _t('serviceStatusOk');
  String get serviceStatusFail => _t('serviceStatusFail');
  String get serviceStatusUnverified => _t('serviceStatusUnverified');
  String get serviceStatusNotApplicable => _t('serviceStatusNotApplicable');
  String get serviceStatusTokenEmpty => _t('serviceStatusTokenEmpty');
  String get serviceStatusDocumentNotFound => _t('serviceStatusDocumentNotFound');
  String serviceStatusProgress(int done, int total) => _t('serviceStatusProgress')
      .replaceAll('{done}', '$done')
      .replaceAll('{total}', '$total');
  String serviceStatusHttp(int code) =>
      _t('serviceStatusHttp').replaceAll('{code}', '$code');
  String get servicesSectionSuccess => _t('servicesSectionSuccess');
  String get servicesSectionFail => _t('servicesSectionFail');
  String get servicesSectionPending => _t('servicesSectionPending');
  String get servicesSectionUnverified => _t('servicesSectionUnverified');
  String get servicesNoItems => _t('servicesNoItems');
  String get servicesWhatsappLink => _t('servicesWhatsappLink');
  String get serviceFirestoreStructure => _t('serviceFirestoreStructure');
  String get serviceStructureDialogTitle => _t('serviceStructureDialogTitle');
  String serviceStructureDialogContent(int count) =>
      _t('serviceStructureDialogContent').replaceAll('{count}', '$count');
  String get serviceStructurePasswordLabel => _t('serviceStructurePasswordLabel');
  String get serviceStructureCreateBtn => _t('serviceStructureCreateBtn');
  String get serviceStructureWrongPassword => _t('serviceStructureWrongPassword');
  String get serviceStructureCreating => _t('serviceStructureCreating');
  String serviceStructureDocsCount(int done, int total) =>
      _t('serviceStructureDocsCount')
          .replaceAll('{done}', '$done')
          .replaceAll('{total}', '$total');
  String serviceStructureMissing(int count, String labels) =>
      _t('serviceStructureMissing')
          .replaceAll('{count}', '$count')
          .replaceAll('{labels}', labels);
  String serviceStructureDocsCreated(int done, int total) =>
      _t('serviceStructureDocsCreated')
          .replaceAll('{done}', '$done')
          .replaceAll('{total}', '$total');
  String get serviceStructureSuccess => _t('serviceStructureSuccess');
  String get serviceStructureDbMissing => _t('serviceStructureDbMissing');

  // Signup
  String get signupTitle => _t('signupTitle');
  String get fullNameLabel => _t('fullNameLabel');
  String get whatsappLabel => _t('whatsappLabel');
  String get phoneNumberLabel => _t('phoneNumberLabel');
  String get isWhatsappNumber => _t('isWhatsappNumber');
  String get isNotWhatsappNumber => _t('isNotWhatsappNumber');
  String get signupInvalidEmailTyping => _t('signupInvalidEmailTyping');
  String get signupPhoneOnlyDigitsMessage => _t('signupPhoneOnlyDigitsMessage');
  String get signupPhoneMinDigitsMessage => _t('signupPhoneMinDigitsMessage');
  String get signupPhoneDigitsLimitReached =>
      _t('signupPhoneDigitsLimitReached');
  String get signupPasswordCriteriaTitle => _t('signupPasswordCriteriaTitle');
  String get signupPasswordRuleLength => _t('signupPasswordRuleLength');
  String get signupPasswordRuleUppercase => _t('signupPasswordRuleUppercase');
  String get signupPasswordRuleLowercase => _t('signupPasswordRuleLowercase');
  String get signupPasswordRuleNumber => _t('signupPasswordRuleNumber');
  String get signupPasswordRuleSpecial => _t('signupPasswordRuleSpecial');
  String get signupPasswordWeakMessage => _t('signupPasswordWeakMessage');
  String get signupPasswordReadyMessage => _t('signupPasswordReadyMessage');
  String get signupNameRequiredMessage => _t('signupNameRequiredMessage');
  String signupPhoneMinDigitsSubmitMessage(String label) =>
      _t('signupPhoneMinDigitsSubmitMessage').replaceAll('{label}', label);
  String get signupLgpdConsentLabel => _t('signupLgpdConsentLabel');
  String get signupLgpdConsentPendingMessage =>
      _t('signupLgpdConsentPendingMessage');
  String get signupLgpdConsentAcceptedMessage =>
      _t('signupLgpdConsentAcceptedMessage');
  String get signupLgpdConsentError => _t('signupLgpdConsentError');
  String get signupTermsReadButton => _t('signupTermsReadButton');
  String get signupGooglePrefilledEmailHint =>
      _t('signupGooglePrefilledEmailHint');
  String signupLinkedClientId(String id) =>
      _t('signupLinkedClientId').replaceAll('{id}', id);
  String signupExistingClientLinkedMessage(String id) =>
      _t('signupExistingClientLinkedMessage').replaceAll('{id}', id);
  String get signupGoogleCompleteButton => _t('signupGoogleCompleteButton');
  String signupPendingRequiredFields(String fields) =>
      _t('signupPendingRequiredFields').replaceAll('{fields}', fields);
  String get registerButton => _t('registerButton');
  String get registrationError => _t('registrationError');
  // Appointment
  String get appointmentsTitle => _t('appointmentsTitle');
  String get newAppointmentTitle => _t('newAppointmentTitle');
  String get dateLabel => _t('dateLabel');
  String get selectTimeHint => _t('selectTimeHint');
  String get massageTypeRelaxante => _t('massageTypeRelaxante');
  String get massageTypeDrenagemLinfatica => _t('massageTypeDrenagemLinfatica');
  String get massageTypeTerapeutica => _t('massageTypeTerapeutica');
  String get massageTypeDesportiva => _t('massageTypeDesportiva');
  String get massageTypePedrasQuentes => _t('massageTypePedrasQuentes');
  String get cancelButton => _t('cancelButton');
  String get scheduleButton => _t('scheduleButton');
  String get appointmentSuccess => _t('appointmentSuccess');
  String get noAppointmentsFound => _t('noAppointmentsFound');
  String get viewingAll => _t('viewingAll');
  String get viewingMine => _t('viewingMine');
  String get myProfileTooltip => _t('myProfileTooltip');
  String get logoutTooltip => _t('logoutTooltip');
  // Profile
  String get profileTitle => _t('profileTitle');
  String get dataTab => _t('dataTab');
  String get historyTab => _t('historyTab');
  String get personalDataTitle => _t('personalDataTitle');
  String get cpfLabel => _t('cpfLabel');
  String get cepLabel => _t('cepLabel');
  String get addressLabel => _t('addressLabel');
  String get birthDateLabel => _t('birthDateLabel');
  String get anamnesisTitle => _t('anamnesisTitle');
  String get medicalHistoryLabel => _t('medicalHistoryLabel');
  String get allergiesLabel => _t('allergiesLabel');
  String get medicationsLabel => _t('medicationsLabel');
  String get surgeriesLabel => _t('surgeriesLabel');
  String get deleteAccountButton => _t('deleteAccountButton');
  String get saveButton => _t('saveButton');
  String get requiredField => _t('requiredField');
  // Waiting Approval
  String get waitingApprovalTitle => _t('waitingApprovalTitle');
  String get analysisTitle => _t('analysisTitle');
  String get contactAdminButton => _t('contactAdminButton');
    String contactAdminButtonWithName(String adminName) =>
            _t('contactAdminButtonWithName').replaceAll('{adminName}', adminName);
  String get backToLoginButton => _t('backToLoginButton');
  String analysisMessage(String date) =>
      _t('analysisMessage').replaceAll('{date}', date);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['pt', 'en', 'es', 'ja', 'fr'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
