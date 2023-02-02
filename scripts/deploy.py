from brownie import Casino, accounts

# code: 123

# funktion um smart-contrat bereitzustellen
def main():
    acct = accounts.load("deployer_metamask")
    return Casino.deploy({"from": acct})
