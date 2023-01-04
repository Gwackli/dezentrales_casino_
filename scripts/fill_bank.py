from brownie import Casino, accounts

# 123
def main():
    acct = accounts.load("deployer_metamask")
    Casino.fill_bank({"from": acct, "value": 10 * 1000000000000000000})
