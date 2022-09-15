from brownie import Casino, accounts

bet_num = 5
bet_value = 1_000_000_000_000_000_000


def test_place_bet():
    account = accounts[0]
    casino = Casino.deploy({"from": account})
    place_bet_transaction = casino.place_bet(
        bet_num, {"from": account, "value": bet_value}
    )
    place_bet_transaction.wait(1)
    bet_block = place_bet_transaction.block_number

    retrieved_bet_number, retrieved_bet_value, retrieved_bet_block = casino.claim()
    assert retrieved_bet_number == bet_num
    assert retrieved_bet_value == bet_value
    assert retrieved_bet_block == bet_block
