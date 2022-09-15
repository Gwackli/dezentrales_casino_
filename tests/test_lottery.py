from brownie import Casino, accounts, reverts

bet_num_min = 1
bet_num_max = 10
bet_num = 5
bet_value_min = 1_000_000_000_000_000_000
bet_value = bet_value_min


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


def test_min_value():
    account = accounts[0]
    casino = Casino.deploy({"from": account})
    with reverts():
        casino.place_bet(bet_num, {"from": account, "value": bet_value_min - 1})


def test_range():
    account = accounts[0]
    casino = Casino.deploy({"from": account})
    with reverts():
        casino.place_bet(bet_num_min - 1, {"from": account, "value": bet_value})
    casino.place_bet(bet_num_min, {"from": account, "value": bet_value})
    with reverts():
        casino.place_bet(bet_num_max + 1, {"from": account, "value": bet_value})
    casino.place_bet(bet_num_max, {"from": account, "value": bet_value})
