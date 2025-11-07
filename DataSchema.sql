CREATE TABLE "User" (
    id SERIAL PRIMARY KEY,
    last_name VARCHAR(100) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(13) UNIQUE,
    goals TEXT,

    CONSTRAINT chk_email_format
    CHECK (email ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),

    CONSTRAINT chk_phone_format
    CHECK (phone IS NULL OR phone ~ '^\+380\d{9}$')
);

CREATE TABLE architectuser (
    user_id INTEGER PRIMARY KEY,
    user_position VARCHAR(150),
    specialization VARCHAR(150),

    CONSTRAINT fk_user
    FOREIGN KEY (user_id)
    REFERENCES "User" (user_id)
    ON DELETE CASCADE
);

CREATE TABLE architecturalstructure (
    structure_id SERIAL PRIMARY KEY,
    structure_name VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE architectureexplanation (
    explanation_id SERIAL PRIMARY KEY,
    structure_id INTEGER NOT NULL,
    construction_styles TEXT NOT NULL,
    creation_year VARCHAR(50) NOT NULL,
    architect VARCHAR(255) NOT NULL,
    historical_data TEXT,
    image_url VARCHAR(1024),
    structure_type VARCHAR(100) NOT NULL,
    structure_location VARCHAR(255) NOT NULL,

    CONSTRAINT fk_structure
    FOREIGN KEY (structure_id)
    REFERENCES architecturalstructure (structure_id)
    ON DELETE RESTRICT,

    CONSTRAINT chk_image_url_format
    CHECK (image_url IS NULL OR image_url ~* '\.(jpeg|jpg|png|gif)$')
);

CREATE TABLE discussion (
    discussion_id SERIAL PRIMARY KEY,
    topic VARCHAR(255) NOT NULL,
    creation_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    initiator_name VARCHAR(255) NOT NULL
);

CREATE TABLE message (
    message_id SERIAL PRIMARY KEY,
    author_id INTEGER NOT NULL,
    discussion_id INTEGER NOT NULL,
    message_text TEXT NOT NULL,
    sent_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    author_name VARCHAR(255) NOT NULL,

    CONSTRAINT fk_author
    FOREIGN KEY (author_id)
    REFERENCES "User" (user_id)
    ON DELETE SET NULL,

    CONSTRAINT fk_discussion
    FOREIGN KEY (discussion_id)
    REFERENCES discussion (discussion_id)
    ON DELETE CASCADE
);

CREATE TABLE discussionparticipant (
    user_id INTEGER NOT NULL,
    discussion_id INTEGER NOT NULL,

    PRIMARY KEY (user_id, discussion_id),

    CONSTRAINT fk_participant_user
    FOREIGN KEY (user_id)
    REFERENCES "User" (user_id)
    ON DELETE CASCADE,

    CONSTRAINT fk_participant_discussion
    FOREIGN KEY (discussion_id)
    REFERENCES discussion (discussion_id)
    ON DELETE CASCADE
);

CREATE TABLE architectrequest (
    architect_id INTEGER NOT NULL,
    explanation_id INTEGER NOT NULL,

    PRIMARY KEY (architect_id, explanation_id),

    CONSTRAINT fk_request_architect
    FOREIGN KEY (architect_id)
    REFERENCES architectuser (user_id)
    ON DELETE CASCADE,

    CONSTRAINT fk_request_explanation
    FOREIGN KEY (explanation_id)
    REFERENCES architectureexplanation (explanation_id)
    ON DELETE CASCADE
);
