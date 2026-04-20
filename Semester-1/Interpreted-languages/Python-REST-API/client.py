import requests
import base64

def main():
    token = base64.b64encode("admin:admin123".encode("utf-8")).decode("utf-8")
    headers = {"Authorization": f"Basic {token}"}

    # POST osoba
    # result = requests.post("http://localhost:8000", headers=headers, data='{"id": 3, "imie": "Andrzej", "nazwisko": "Kowal", "rok_uro": 2001}')
   
    # print(result.text)

    result = requests.get("http://localhost:8000/osoby", headers=headers)
    print(result.status_code, " - " , result.text)

    result = requests.put("http://localhost:8000/osoba/3", headers=headers, data='{"id": 3, "imie": "Andrzej", "nazwisko": "Kowal", "rok_uro": 2005}')
    print(result.status_code, " - " , result.text)


    result = requests.get("http://localhost:8000/osoba/3", headers=headers)
    print(result.status_code, " - " , result.text)

    result = requests.delete("http://localhost:8000/osoba/3", headers=headers)
    print(result.status_code, " - " , result.text)


    result = requests.get("http://localhost:8000/osoba/3", headers=headers)
    print(result.status_code, " - " , result.text)

if __name__ == "__main__":
    main()
