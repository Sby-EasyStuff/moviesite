# Movie Site

Movie site è un database di film che permette agli utenti di aggiungere promemoria per i film in uscita
---

### Esperienza utente

- Utenti non autenticati
  - Possono visualizzare solo l'homepage e le pagine con gli elenchi di film, utenti e ultime ricerche
- Utenti autenticati
  - Possono commentare i vari film
  - Aggiungere promemoria per i film in uscita
  - Visualizzare le informazioni degli altri Utenti
  - Cercare/aggiungere nuovi film al database
---

### Specifiche tecniche

Il framework utilizzato è `Ruby on Rails`.
Per testare l'applicazione in locale si devono seguire questi passi:

- installare Ruby on Rails

- dal terminale
    - `nano ~/.bashrc`
    - aggiungere in fondo al file:
      - export GOOGLE_APP_ID= **CLIENT_ID**
      - export GOOGLE_APP_SECRET= **CLIENT_SECRET**
      - export TMDB_KEY= **TMDB_API_ID**
      - export YT_KEY= **YOUTUBE_KEY_ID**
      - export CLOUDAMQP_URL= **AMQP_URL**
    - `bundle install`
    - `rails db:migrate`
    - `rails s`

> Dove **CLIENT_ID**, **CLIENT_SECRET** e **YOUTUBE_KEY_ID** si ottengono registrandosi su [Google Developer Console](https://console.developers.google.com),
> **TMDB_API_ID** si ottiene registrandosi su [The Movie DB](https://www.themoviedb.org/documentation/api),
> **AMQP_URL** si ottiene registrandosi su [Cloud AMPQ](https://www.cloudamqp.com/).


---

### API REST

- Autenticazione
    + [Google Plus API](https://developers.google.com/+/web/api/rest/)
- Caricamento trailer
    + [YouTube API](https://developers.google.com/youtube/v3/getting-started)
- Database film
    + [The Movie DB](https://www.themoviedb.org/documentation/api)
- Calendario promemoria
    + [Google Calendar API](https://developers.google.com/calendar/overview)
