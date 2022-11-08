from brownie import Casino, accounts, reverts
import pytest

# deffinieren der bereiche und des mindestbetrag
bet_num_min = 1
range = 1
bet_num = 1
bet_value_min = 1_000_000_000_000_000_000
bet_value = bet_value_min


@pytest.fixture(scope="module")
def casino():
    account = accounts[0]
    # casino = Casino.deploy({"from": account})
    casino = Casino.deploy({"from": account})
    casino.fill_bank({"from": accounts[3], "value": 10 * bet_value})
    return casino


# testen ob eine einfache Wette abgeschlossen werden kann
def test_place_bet(casino):
    account = accounts[1]

    place_bet_transaction = casino.place_bet(
        bet_num, range, {"from": account, "value": bet_value}
    )
    place_bet_transaction.wait(1)
    bet_block = place_bet_transaction.block_number

    casino.claim({"from": account, "value": 0})
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


# testen ob der Ersteller des Contracts X Amount vom contract wieder entfernen kann
def test_owner_can_empty_bank(casino):
    account = accounts[0]
    casino.fill_bank({"from": accounts[3], "value": 2 * bet_value})
    casino.empty_bank(bet_value, {"from": account})


# testen dass keine andere Person Geld entfernen kann
def test_not_owner_cannot_empty_bank(casino):
    account = accounts[1]
    casino.fill_bank({"from": accounts[3], "value": 2 * bet_value})
    with reverts():
        casino.empty_bank(bet_value, {"from": account})


# testen dass man nicht mit zu wenig beitreten kann
def test_min_value(casino):
    account = accounts[0]
    # casino = Casino.deploy({"from": account})
    with reverts():
        casino.place_bet(bet_num, range, {"from": account, "value": bet_value_min - 1})


# teste, dass man nur auf erlaubte Zahlen setzten kann
def test_range_to_small(casino):
    account = accounts[0]
    # casino = Casino.deploy({"from": account})
    with reverts():
        casino.place_bet(bet_num_min - 1, range, {"from": account, "value": bet_value})


# testen dass die mindestzahl geht
def test_range_min(casino):
    account = accounts[0]
    # casino = Casino.deploy({"from": account})
    casino.place_bet(bet_num_min, range, {"from": account, "value": bet_value})


# testen dass über der range nicht geht
def test_range_to_big(casino):
    account = accounts[0]
    # casino = Casino.deploy({"from": account})
    with reverts():
        casino.place_bet(
            bet_num_min + range + 1, range, {"from": account, "value": bet_value}
        )


# testen dass das obere Ende noch geht
def test_range_max(casino):
    account = accounts[0]
    # casino = Casino.deploy({"from": account})
    casino.place_bet(bet_num_min + range, range, {"from": account, "value": bet_value})
