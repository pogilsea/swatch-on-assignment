create table customer
(
    id         int auto_increment
        primary key,
    name       varchar(255)                       not null,
    phone      varchar(13)                        null,
    email      varchar(255)                       null,
    created_at datetime default CURRENT_TIMESTAMP null
)
    comment 'CS 인바운드 고객 테이블';

create table swatch_on.customer_service_manager
(
    id         int auto_increment
        primary key,
    name       varchar(255)                        not null,
    email      varchar(255)                        null,
    role       enum ('communicator', 'respondent') not null,
    created_at datetime default CURRENT_TIMESTAMP  null
)
    comment 'CS 담당자 테이블';

create table customer_service_channel
(
    id              int auto_increment
        primary key,
    communicator_id int                                                                                                                                 null comment '연락담당자 아이디',
    respondent_id   int                                                                                                                                 null comment '처리담당자 아이디',
    customer_id     int                                                                                                                                 null comment '고객 아이디',
    type            enum ('inbound', 'outbound')                                                                                                        not null comment 'CS 종류',
    status          enum ('receive_cs', 'assign_respondent', 'register_respondent_feed', 'require_customer_feed', 'register_customer_feed', 'complete') not null comment 'CS 처리 상태
receive_cs: CS 문의 접수
assign_respondent: 처리 담당자에게 CS 할당
register_respondent_feed: 처리 담당자가 답변을 등록
require_customer_feed: 고객으로부터 확인 필요
register_customer_feed: 아웃 바운드 고객 답변 등록
complete: CS 종료',
    created_at      datetime default CURRENT_TIMESTAMP                                                                                                  null,
    constraint customer_service_channel_customer_id_fk
        foreign key (customer_id) references customer (id)
            on delete set null,
    constraint customer_service_channel_customer_service_manager_id_fk
        foreign key (communicator_id) references customer_service_manager (id)
            on delete set null,
    constraint customer_service_channel_customer_service_manager_id_fk_2
        foreign key (respondent_id) references customer_service_manager (id)
            on delete set null
)
    comment '고객 CS 단위 테이블';

create index customer_service_channel_status_index
    on customer_service_channel (status);

create index customer_service_channel_type_index
    on customer_service_channel (type);

create table customer_service_message
(
    id              int auto_increment
        primary key,
    writer_type     enum ('customer', 'worker') null comment '메시지 수신 발신처 타입',
    channel_id      int                         not null comment '채널 아이디',
    message_content int                         null comment '메세지 내용',
    created_at      datetime                    null comment '등록일',
    constraint customer_service_message_customer_service_channel_id_fk
        foreign key (channel_id) references customer_service_channel (id)
            on delete cascade
)
    comment 'CS 상담 메세지 테이블';

create table customer_service_tag
(
    id   int auto_increment
        primary key,
    name varchar(60) not null
)
    comment 'CS 상담 태그 리스트 테이블';

create table customer_service_channel_tag
(
    channel_id int not null,
    tag_id     int not null,
    constraint customer_service_channel_tag_customer_service_channel_id_fk
        foreign key (channel_id) references customer_service_channel (id)
            on delete cascade,
    constraint customer_service_channel_tag_customer_service_tag_id_fk
        foreign key (tag_id) references customer_service_tag (id)
            on delete cascade
)
    comment 'CS 상담 건 단위 태그 테이블';

