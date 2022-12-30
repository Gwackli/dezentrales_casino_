from brownie import Casino, accounts

# 123
def main():
    acct = accounts.load("deployer_metamask")
    return Casino.deploy({"from": acct})
