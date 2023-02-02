# Dezentrales Casino

## Features
* Erstellen von Wetten
* Abholen seines Gewinns
* Auffüllen des Geldpools
* Abheben vom Geldpool
* Ändern von Maximalenwettbetrag


## Installation
```
git clone https://github.com/Gwackli/dezentrales_casino_/
```

### Brownie
install pipx
```
python3 -m pip install --user pipx
python3 -m pipx ensurepath
```
install of brownie
```
pipx install eth-brownie
```
Mehr Informationen [hier](https://eth-brownie.readthedocs.io/en/stable/install.html)


### Ganache
[hier](https://trufflesuite.com/ganache/) downloaden mit grafischer Oberfläche

### add accounts
ACCOUNTNAME kann selber gewählt werden
```
brownie accounts new ACCOUNTNAME
```
### add Network
Zu erst Erstellung von einem Quicknode konto, in welchem eine Url für das mumbai testnet erstellt wurde
```
brownie networks add MumbaiAlchemy ropstenquicknode host=YOUR_QUICKNODE_URL
```

### deploy
```
brownie run deploy.py --network MumbaiAlchemy
```

### fill bank
ACCOUNTNAME muss ersetzt werden durch den eigenen Account name in Brownie
```
brownie console --network MumbaiAlchemy
casino = Casino[0] //random
casino.fill_bank({"from": accounts.load("ACCOUNTNAME"), "value": 10 * 1000000000000000000})
```

## wichtige Fakten
### Mumbai Polygonscan
[always win](https://mumbai.polygonscan.com/address/0x156B03A252689861E3aC9307f359608720DBF409)

[Random win](https://mumbai.polygonscan.com/address/0x5dB3eE642937932dC930f588ee128F52A9641eDb)
