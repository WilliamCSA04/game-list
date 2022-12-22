CREATE SCHEMA IF NOT EXISTS public;
CREATE EXTENSION IF NOT EXISTS pgcrypto with SCHEMA public;

CREATE TABLE public.plataform (
    id character(28) PRIMARY KEY,
    name text NOT NULL,
    release_year varchar(4) NOT NULL,
    url_image text NOT NULL,
    created_at timestamp with time zone DEFAULT current_timestamp
);

CREATE TABLE public.game (
    id character(28) PRIMARY KEY,
    name text NOT NULL,
    release_year varchar(4) NOT NULL,
    url_image text NOT NULL,
    created_at timestamp with time zone DEFAULT current_timestamp
);

CREATE TABLE public.user (
    id character(28) PRIMARY KEY,
    name text NOT NULL,
    email text NOT NULL,
    password text NOT NULL,
    avatar_url text,
    created_at timestamp with time zone DEFAULT current_timestamp,
    CONSTRAINT user_email UNIQUE (email)
);

CREATE TABLE public.user_game (
    id character(28) PRIMARY KEY,
    user_id character(28) NOT NULL,
    game_id character(28) NOT NULL,
    created_at timestamp with time zone DEFAULT current_timestamp,
    CONSTRAINT user_game_user_id_fk FOREIGN KEY (user_id) REFERENCES public.user(id),
    CONSTRAINT user_game_game_id_fk FOREIGN KEY (game_id) REFERENCES public.game(id)
);

CREATE TABLE public.user_game_plataform (
    id character(28) PRIMARY KEY,
    user_game_id character(28) NOT NULL,
    plataform_id character(28) NOT NULL,
    created_at timestamp with time zone DEFAULT current_timestamp,

    CONSTRAINT user_plataform_user_game_id_fk FOREIGN KEY (user_game_id) REFERENCES public.user_game(id), 
    CONSTRAINT user_plataform_plataform_id_fk FOREIGN KEY (plataform_id) REFERENCES public.plataform(id)
);

CREATE TYPE ratingtype AS ENUM (
    'GAMEPLAY',
    'LORE',
    'GRAPHICS',
    'SOUNDTRACK'
);

CREATE TABLE public.rating (
    id character(28) PRIMARY KEY,
    type ratingtype NOT NULL,
    value integer NOT NULL,
    user_game_id character(28) NOT NULL,
    created_at timestamp with time zone DEFAULT current_timestamp,
    
    CONSTRAINT rating_user_game_id_fk FOREIGN KEY (user_game_id) REFERENCES public.user_game(id),
    CONSTRAINT ensure_mutual UNIQUE (type, value),
    CONSTRAINT value_range_check CHECK (
        value > 0 AND value < 6
    )
);
