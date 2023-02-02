pragma solidity ^0.6.6;

contract Casino {
    //jeweils gesetzte zahl, gewetteter Betrag und den Block speichern in den Variablen
    mapping(address => uint256) public block_numbers;
    mapping(address => uint256) public bet_numbers;
    mapping(address => uint256) public bet_values;
    mapping(address => uint256) public bet_min_number;
    mapping(address => uint256) public bet_range;

    //definierte Werte
    uint256 min_value = 1_000_000_000_000_000_000; //1 Matic
    uint256 max_value = 10_000_000_000_000_000_000; //10 Matic
    uint256 max_ratio_bet_to_contract_balance = 5; //Der theoretisch möglich Gewinn muss
    //x-mal kleiner sein als die contract balance
    uint256 min_number = 1;
    //uint256 max_number = 2;
    //uint256 range = max_number - min_number + 1;

    //90 von 100 -> 0.9
    uint256 house_edge = 90;

    //Adresse für den Owner des Smart-Contracts
    address private owner;

    //Constructor wird bei Erstellung ausgeführt
    //Es wird gespeichert wer den Smart-Contract deployed hat
    constructor() public {
        owner = msg.sender;
    }

    //Funktion um die Bank wieder zu füllen mit Matic
    function fill_bank() public payable {}

    //Funktion um Matic aus der Bank zu entfernen
    //Als Parameter wird der Betrag angegeben
    function empty_bank(uint256 amount) public {
        require(msg.sender == owner);
        (bool sent, bytes memory data) = owner.call{value: amount}("");
        require(sent, "Failed to send Ether");
    }

    //Funktion um den maximalen Wettbetrag zu ändern
    function change_max_value(uint256 value) public {
        require(msg.sender == owner);
        max_value = value;
    }

    //Funktion um den change_ratio_payout_balance zu ändern
    function change_ratio_payout_balance(uint256 value) public {
        require(msg.sender == owner);
        max_ratio_bet_to_contract_balance = value;
    }

    //Funktion um eine Wette zu erstellen
    function place_bet(uint256 bet_number, uint256 range) public payable {
        //uberprufen ob der mindestbetrag bezahlt wurde
        require(msg.value >= min_value, "Not enough Matic");
        //uberprufen ob nicht zu viel gewettet wurde
        require(msg.value <= max_value, "Too much Matic");

        //eine gültige Range angeben
        require(range > 0);

        //uberprufen, dass der contract nicht komplett geleert wird mit einer Wette
        require(
            msg.value * range * max_ratio_bet_to_contract_balance <=
                address(this).balance,
            "Kleinere range oder kleineren Wettbetrag setzen"
        );

        //uberprufen ob die gesetzte zahl im beriech der zufallszahl ist
        require(
            bet_number >= min_number && bet_number <= min_number + range,
            "Number not in range"
        );

        //Die wichtigen Werte speichern
        block_numbers[msg.sender] = block.number;
        bet_numbers[msg.sender] = bet_number;
        bet_values[msg.sender] = msg.value;
        bet_range[msg.sender] = range;
    }

    //Funktion um den Gewinner auszuzahlen
    //Parameter sind die Adresse des Gewinnners und der Betrag
    function send_win(address winner, uint256 amount) private {
        (bool sent, bytes memory data) = winner.call{value: amount}("");
        require(sent, "Failed to send Ether");
    }

    //Funktion um seinen Gewinn zu bekommen
    function claim() public {
        //uperprufen, dass genugend block vergangen sind
        require(
            block_numbers[msg.sender] + 2 < block.number,
            "You have to wait for more blocks to pass"
        );

        //generieren der Zufallszahl
        uint256 random_number = (uint256(
            keccak256(
                abi.encodePacked(blockhash(block_numbers[msg.sender] + 1))
            )
        ) % bet_range[msg.sender]) + min_number;

        //uberprufen ob gewonnen
        require(random_number == bet_numbers[msg.sender], "You didn't win");

        //auszahlen
        send_win(
            msg.sender,
            ((bet_values[msg.sender] * bet_range[msg.sender] * house_edge)) /
                100
        );

        //Den Wert der Wette auf 9 setzen
        //Durch dies kann die Wette nicht mehrmals ausgezahlt werden
        bet_values[msg.sender] = 0;
    }
}
