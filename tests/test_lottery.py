from brownie import Casino, accounts, reverts

# deffinieren der bereiche und des mindestbetrag
bet_num_min = 1
bet_num_max = 2
bet_num = 1
bet_value_min = 1_000_000_000_000_000_000
bet_value = bet_value_min


# testen ob eine einfache Wette abgeschlossen werden kann
def test_place_bet():
    account = accounts[1]
    casino = Casino.deploy({"from": account})

    place_bet_transaction = casino.place_bet(
        bet_num, {"from": account, "value": bet_value}
    )
    place_bet_transaction.wait(1)
    bet_block = place_bet_transaction.block_number

    casino.fill_bank({"from": accounts[3], "value": 8 * bet_value})

    casino.claim()
    """(
        retrieved_bet_number,
        retrieved_bet_value,
        retrieved_bet_block,
        random_number,
    ) = casino.claim()
    assert random_number == 1
    assert retrieved_bet_number == bet_num
    assert retrieved_bet_value == bet_value
    assert retrieved_bet_block == bet_block"""


# testen dass man nicht mit zu wenig beitreten kann
def test_min_value():
    account = accounts[0]
    casino = Casino.deploy({"from": account})
    with reverts():
        casino.place_bet(bet_num, {"from": account, "value": bet_value_min - 1})


# teste, dass man nur auf erlaubte Zahlen setzten kann
def test_range_min():
    account = accounts[0]
    casino = Casino.deploy({"from": account})
    with reverts():
        casino.place_bet(bet_num_min - 1, {"from": account, "value": bet_value})


def test_range_to_small():
    account = accounts[0]
    casino = Casino.deploy({"from": account})
    casino.place_bet(bet_num_min, {"from": account, "value": bet_value})


def test_range_max():
    account = accounts[0]
    casino = Casino.deploy({"from": account})
    with reverts():
        casino.place_bet(bet_num_max + 1, {"from": account, "value": bet_value})


def test_range_to_big():
    account = accounts[0]
    casino = Casino.deploy({"from": account})
    casino.place_bet(bet_num_max, {"from": account, "value": bet_value})
