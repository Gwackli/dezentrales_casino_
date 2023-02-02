from brownie import Casino, accounts

# 123

# Funktion um dem Smart-contract geld aufzuladne
def main():
    acct = accounts.load("deployer_metamask")
    Casino.fill_bank({"from": acct, "value": 10 * 1000000000000000000})
