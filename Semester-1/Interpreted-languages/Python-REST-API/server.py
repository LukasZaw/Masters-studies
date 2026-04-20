# -*- coding: utf-8 -*-
from http.server import HTTPServer, BaseHTTPRequestHandler
import json

from io import BytesIO

import base64
import binascii

from pymsgbox import password

UZYTKOWNICY = {
"admin": "admin123",
"student": "haslo123"
}

class Osoba:
    def __init__(self, id, imie, nazwisko, rok_uro):
        self.id = id
        self.imie = imie
        self.nazwisko = nazwisko
        self.rok_uro = rok_uro

    def to_dict(self):
        return {
            "id": self.id,
            "imie": self.imie,
            "nazwisko": self.nazwisko,
            "rok_uro": self.rok_uro
        }


# zapis do pliku
def zapisz_osoby(body, plik="baza.json"):
    if isinstance(body, bytes):
        body = body.decode("utf-8")

    nowe_dane = json.loads(body)

    if not isinstance(nowe_dane, list):
        nowe_dane = [nowe_dane]

    try:
        with open(plik, "r", encoding="utf-8") as f:
            stare_dane = json.load(f)
    except (FileNotFoundError, json.JSONDecodeError):
        stare_dane = []

    stare_dane.extend(nowe_dane)

    with open(plik, "w", encoding="utf-8") as f:
        json.dump(stare_dane, f, indent=4, ensure_ascii=False)


# odczyt z pliku
def wczytaj_osoby(plik="baza.json"):
    try:
        with open(plik, "r", encoding="utf-8") as f:
            dane = json.load(f)
            return [Osoba(**o) for o in dane]
    except FileNotFoundError:
        return []

osoby = []



class SimpleHTTPRequestHandler(BaseHTTPRequestHandler):
    def do_AUTHHEAD(self):
        self.send_response(401)
        self.send_header("WWW-Authenticate", 'Basic realm="API"')
        self.send_header("Content-Type", "text/plain; charset=utf-8")
        self.end_headers()
        self.wfile.write("Brak autoryzacji".encode("utf-8"))

    def is_authorized(self):
        auth_header = self.headers.get("Authorization")
        if not auth_header or not auth_header.startswith("Basic "):
            return False

        encoded_part = auth_header.split(" ", 1)[1]
        try:
            decoded = base64.b64decode(encoded_part).decode("utf-8")
        except (binascii.Error, UnicodeDecodeError):
            return False

        if ":" not in decoded:
            return False

        username, password = decoded.split(":", 1)
        return UZYTKOWNICY.get(username) == password

    def do_GET(self):
        if not self.is_authorized():
            self.do_AUTHHEAD()
            return
        
        print(self.path)
        if self.path == "/osoby":
            osoby = wczytaj_osoby()

            dane = [o.__dict__ for o in osoby]

            json_data = json.dumps(dane, ensure_ascii=False)

            self.send_response(200)
            self.send_header("Content-Type", "application/json; charset=utf-8")
            self.end_headers()

            self.wfile.write(json_data.encode("utf-8"))
            return
        
        if self.path.startswith("/osoba/"):
            id_str = self.path.split("/")[-1]
            id = int(id_str)

            osoby = wczytaj_osoby()
            osoba = next((o for o in osoby if o.id == id), None)

            if osoba:
                self.send_response(200)
                self.send_header("Content-Type", "application/json; charset=utf-8")
                self.end_headers()

                self.wfile.write(json.dumps(osoba.to_dict()).encode("utf-8"))
            else:
                self.send_response(404)
                self.end_headers()
                self.wfile.write(b"Nie znaleziono osoby")
            return

        self.send_response(404)
        self.end_headers()

    # POST
    def do_POST(self):
        if not self.is_authorized():
            self.do_AUTHHEAD()
            return
        print(self.path)
        content_length = int(self.headers['Content-Length'])
        body = self.rfile.read(content_length)
        print(body)
        print(body.decode())

        zapisz_osoby(body)

        self.send_response(200)
        self.end_headers()


        

        response = BytesIO()
        response.write('Żądanie POST\n'.encode())
        response.write(b'Otrzymano:\n')
        response.write(body)
        self.wfile.write(response.getvalue())
        
    def do_PUT(self):
        if not self.is_authorized():
            self.do_AUTHHEAD()
            return
        print(self.path)
        if self.path.startswith("/osoba/"):
            id_str = self.path.split("/")[-1]
            id = int(id_str)

            content_length = int(self.headers['Content-Length'])
            body = self.rfile.read(content_length)

            if isinstance(body, bytes):
                body = body.decode("utf-8")

            nowe_dane = json.loads(body)

            osoby = wczytaj_osoby()
            znaleziono = False

            for o in osoby:
                if o.id == id:
                    o.imie = nowe_dane.get("imie", o.imie)
                    o.nazwisko = nowe_dane.get("nazwisko", o.nazwisko)
                    o.rok_uro = nowe_dane.get("rok_uro", o.rok_uro)
                    znaleziono = True
                    break

            if not znaleziono:
                self.send_response(404)
                self.end_headers()
                self.wfile.write(b"Nie znaleziono osoby")
                return

            with open("baza.json", "w", encoding="utf-8") as f:
                json.dump([o.to_dict() for o in osoby], f, indent=4, ensure_ascii=False)

            self.send_response(200)
            self.send_header("Content-Type", "application/json; charset=utf-8")
            self.end_headers()
            return

        self.send_response(404)
        self.end_headers()



    def do_DELETE(self):
        if not self.is_authorized():
            self.do_AUTHHEAD()
            return
        print(self.path)
        if self.path.startswith("/osoba/"):
            id_str = self.path.split("/")[-1]
            id = int(id_str)

            osoby = wczytaj_osoby()

            nowe_osoby = [o for o in osoby if o.id != id]


            if len(nowe_osoby) == len(osoby):
                # nic nie usunięto
                self.send_response(404)
                self.end_headers()
                self.wfile.write(b"Nie znaleziono osoby")
                return
        
            with open("baza.json", "w", encoding="utf-8") as f:
                json.dump([o.to_dict() for o in nowe_osoby], f, indent=4, ensure_ascii=False)
            
            self.send_response(200)
            self.end_headers()
            return

        self.send_response(404)
        self.end_headers()

def main():
    httpd = HTTPServer(('localhost', 8000), SimpleHTTPRequestHandler)
    httpd.serve_forever()
    
    
if __name__ == "__main__":
    main()