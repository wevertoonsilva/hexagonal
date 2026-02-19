create table db_doc_hub.requisicao_documento
(
    id                 bigint unsigned auto_increment
        primary key,
    chave_requisicao   varchar(160)                             not null,
    id_correlacao      varchar(120)                             not null,
    topico_origem      varchar(255)                             not null,
    id_evento_origem   varchar(120)                             null,
    tenant             varchar(80)                              not null,
    tipo_documento     varchar(40)                              not null,
    canal_envio        varchar(40)                              not null,
    status             varchar(40)                              not null,
    etapa_atual        varchar(80)                              null,
    referencia_cliente varchar(120)                             null,
    prioridade         int         default 0                    not null,
    data_criacao       datetime(3) default CURRENT_TIMESTAMP(3) not null,
    data_atualizacao   datetime(3) default CURRENT_TIMESTAMP(3) not null on update CURRENT_TIMESTAMP(3),
    data_conclusao     datetime(3)                              null,
    constraint uk_requisicao_documento_chave_requisicao
        unique (chave_requisicao)
);

create table db_doc_hub.envio_documento
(
    id               bigint unsigned auto_increment
        primary key,
    id_requisicao    bigint unsigned                          not null,
    provedor_envio   varchar(20)                              not null,
    canal_envio      varchar(40)                              not null,
    status           varchar(30)                              not null,
    data_envio       datetime(3)                              null,
    data_entrega     datetime(3)                              null,
    data_criacao     datetime(3) default CURRENT_TIMESTAMP(3) not null,
    data_atualizacao datetime(3) default CURRENT_TIMESTAMP(3) not null on update CURRENT_TIMESTAMP(3),
    constraint fk_envio_documento_requisicao
        foreign key (id_requisicao) references db_doc_hub.requisicao_documento (id)
            on delete cascade
);

create index idx_envio_documento_canal_status_envio
    on db_doc_hub.envio_documento (canal_envio, status, data_envio);

create index idx_envio_documento_provedor_status_atualizacao
    on db_doc_hub.envio_documento (provedor_envio, status, data_atualizacao);

create index idx_envio_documento_requisicao
    on db_doc_hub.envio_documento (id_requisicao);

create table db_doc_hub.evento_envio_documento
(
    id                 bigint unsigned auto_increment
        primary key,
    id_envio_documento bigint unsigned                          not null,
    tipo_evento        varchar(60)                              not null,
    id_evento_externo  varchar(120)                             null,
    data_evento        datetime(3)                              not null,
    data_criacao       datetime(3) default CURRENT_TIMESTAMP(3) not null,
    constraint uk_evento_envio_documento_evento_externo
        unique (id_evento_externo),
    constraint fk_evento_envio_documento_envio
        foreign key (id_envio_documento) references db_doc_hub.envio_documento (id)
            on delete cascade
);

create index idx_evento_envio_documento_envio_data_evento
    on db_doc_hub.evento_envio_documento (id_envio_documento, data_evento);

create index idx_evento_envio_documento_tipo_data_evento
    on db_doc_hub.evento_envio_documento (tipo_evento, data_evento);

create table db_doc_hub.execucao_etapa_documento
(
    id            bigint unsigned auto_increment
        primary key,
    id_requisicao bigint unsigned                          not null,
    nome_etapa    varchar(80)                              not null,
    versao_etapa  int         default 1                    not null,
    tentativa     int         default 1                    not null,
    status        varchar(30)                              not null,
    data_inicio   datetime(3)                              not null,
    data_fim      datetime(3)                              null,
    duracao_ms    int                                      null,
    codigo_erro   varchar(80)                              null,
    mensagem_erro varchar(1000)                            null,
    id_worker     varchar(120)                             null,
    data_criacao  datetime(3) default CURRENT_TIMESTAMP(3) not null,
    constraint uk_execucao_etapa_documento_req_etapa_tentativa
        unique (id_requisicao, nome_etapa, tentativa),
    constraint fk_execucao_etapa_documento_requisicao
        foreign key (id_requisicao) references db_doc_hub.requisicao_documento (id)
            on delete cascade
);

create index idx_execucao_etapa_documento_etapa_status_inicio
    on db_doc_hub.execucao_etapa_documento (nome_etapa, status, data_inicio);

create index idx_execucao_etapa_documento_req_etapa_status
    on db_doc_hub.execucao_etapa_documento (id_requisicao, nome_etapa, status);

create index idx_execucao_etapa_documento_req_inicio
    on db_doc_hub.execucao_etapa_documento (id_requisicao, data_inicio);

create table db_doc_hub.outbox_requisicao_documento
(
    id              bigint unsigned auto_increment
        primary key,
    id_requisicao   bigint unsigned                          not null,
    tipo_evento     varchar(80)                              not null,
    status          varchar(20)                              not null,
    tentativas      int         default 0                    not null,
    data_criacao    datetime(3) default CURRENT_TIMESTAMP(3) not null,
    data_publicacao datetime(3)                              null,
    constraint fk_outbox_requisicao_documento_requisicao
        foreign key (id_requisicao) references db_doc_hub.requisicao_documento (id)
            on delete cascade
);

create index idx_outbox_requisicao_tipo
    on db_doc_hub.outbox_requisicao_documento (id_requisicao, tipo_evento);

create index idx_outbox_status_data_criacao
    on db_doc_hub.outbox_requisicao_documento (status, data_criacao);

create index idx_requisicao_documento_id_correlacao
    on db_doc_hub.requisicao_documento (id_correlacao);

create index idx_requisicao_documento_referencia_cliente_data_criacao
    on db_doc_hub.requisicao_documento (referencia_cliente, data_criacao);

create index idx_requisicao_documento_status_data_criacao
    on db_doc_hub.requisicao_documento (status, data_criacao);

create index idx_requisicao_documento_tenant_data_criacao
    on db_doc_hub.requisicao_documento (tenant, data_criacao);

create index idx_requisicao_documento_tipo_canal_data_criacao
    on db_doc_hub.requisicao_documento (tipo_documento, canal_envio, data_criacao);

create table db_doc_hub.saida_etapa_documento
(
    id                bigint unsigned auto_increment
        primary key,
    id_execucao_etapa bigint unsigned                          not null,
    chave_saida       varchar(120)                             not null,
    dados             json                                     not null,
    sensivel          tinyint(1)  default 0                    not null,
    data_criacao      datetime(3) default CURRENT_TIMESTAMP(3) not null,
    constraint uk_saida_etapa_documento_execucao_chave
        unique (id_execucao_etapa, chave_saida),
    constraint fk_saida_etapa_documento_execucao
        foreign key (id_execucao_etapa) references db_doc_hub.execucao_etapa_documento (id)
            on delete cascade
);

create index idx_saida_etapa_documento_chave_data_criacao
    on db_doc_hub.saida_etapa_documento (chave_saida, data_criacao);

create index idx_saida_etapa_documento_execucao
    on db_doc_hub.saida_etapa_documento (id_execucao_etapa);

