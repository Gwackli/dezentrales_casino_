from brownie import Casino, accounts


def test_place_bet():
    account = accounts[0]
    casino = Casino.deploy({"from": account})
    place_bet_transaction = casino.place_bet(
        5, {"from": account, "value": 1000000000000000000}
    )
    place_bet_transaction.wait(1)

    retrieved_number = Casino.claim()
    assert retrieved_number == 5
