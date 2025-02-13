-- 이벤트 테이블 생성
CREATE TABLE events
(
    event_id BIGINT
    AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR
    (200) NOT NULL,
    description TEXT,
    start_date DATETIME NOT NULL,
    end_date DATETIME NOT NULL,
    status VARCHAR
    (20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON
    UPDATE CURRENT_TIMESTAMP
    );
-- status 업데이트를 위한 트리거 생성
DELIMITER //
    CREATE TRIGGER before_event_insert BEFORE
    INSERT ON
    events
    FOR
    EACH
    ROW
    BEGIN
        IF NEW.end_date < NOW() THEN
        SET NEW
        .status = 'FINISHED';
    ELSEIF NEW.start_date <= NOW
    () AND NEW.end_date >= NOW
    () THEN
    SET NEW
    .status = 'IN_PROGRESS';
    ELSE
    SET NEW
    .status = 'UPCOMING';
    END
    IF;
END;//

    CREATE TRIGGER before_event_update BEFORE
    UPDATE ON events
FOR EACH ROW
    BEGIN
        IF NEW.end_date < NOW() THEN
        SET NEW
        .status = 'FINISHED';
    ELSEIF NEW.start_date <= NOW
    () AND NEW.end_date >= NOW
    () THEN
    SET NEW
    .status = 'IN_PROGRESS';
    ELSE
    SET NEW
    .status = 'UPCOMING';
    END
    IF;
END;//
DELIMITER ;

    -- 테스트 데이터 삽입
    INSERT INTO events
        (title, description, start_date, end_date)
    VALUES
        ('여름 할인 이벤트', '전 상품 20% 할인', '2024-07-01 00:00:00', '2024-08-31 23:59:59'),
        ('봄맞이 이벤트', '신상품 10% 할인', '2024-03-01 00:00:00', '2024-03-31 23:59:59'),
        ('크리스마스 이벤트', '시즌 한정 상품', '2024-12-01 00:00:00', '2024-12-25 23:59:59'); 