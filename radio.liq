# Configurações do Spotify
CLIENT_ID = "784d37e9b86342e4932ff727642d6262"
CLIENT_SECRET = "b4d54dda68f040b78c40a560ade48614"
PLAYLIST_ID = "I5DPpWQx1RLWRHqkkEKfCTG?si=1ffa631b9ed54e90"

# Função para obter o token do Spotify
def get_spotify_token() =
    auth_string = base64.encode("CLIENT_ID:CLIENT_SECRET")
    response = http.get("https://accounts.spotify.com/api/token", [
        "Authorization" => "Basic " + auth_string,
        "Content-Type" => "application/x-www-form-urlencoded"
    ], "grant_type=client_credentials")
    
    return response["access_token"]
end

# Função para obter as músicas da playlist
def get_playlist_tracks(token) =
    response = http.get("https://api.spotify.com/v1/playlists/" + PLAYLIST_ID + "/tracks", [
        "Authorization" => "Bearer " + token
    ])
    
    return List.map(response["items"], fun(track) -> track["track"]["external_urls"]["spotify"])
end

# Função principal para tocar músicas
def spotify_stream() =
    token = get_spotify_token()
    tracks = get_playlist_tracks(token)
    track_url = List.random(tracks)
    
    return stream(track_url)
end

# Iniciar o fluxo
output.icecast(%mp3, host = "localhost", port = 8000, password = "senha_source", mount = "stream", source = spotify_stream())
