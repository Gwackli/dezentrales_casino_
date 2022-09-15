pragma solidity ^0.6.6;

contract Casino {
    //jeweils gesetzte zahl, gewetteter Betrag und den Block speichern in den Variablen
    mapping(address => uint256) public block_numbers;
    mapping(address => uint256) public bet_numbers;
    mapping(address => uint256) public bet_values;

    //definierte Werte
    uint256 min_value = 1_000_000_000_000_000_000;
    uint256 min_number = 1;
    uint256 max_number = 10;

    //Funktion um eine Wette zu erstellen
    function place_bet(uint256 bet_number) public payable {
        //uberprufen ob der mindestbetrag bezahlt wurde
        require(msg.value >= min_value, "Not enough Matic");

        //uberprufen ob die gesetzte zahl im beriech der zufallszahl ist
        require(
            bet_number >= min_number && bet_number <= max_number,
            "Number not in range"
        );

        //Die wichtigen Werte speichern
        block_numbers[msg.sender] = block.number;
        bet_numbers[msg.sender] = bet_number;
        bet_values[msg.sender] = msg.value;
    }

    function claim()
        public
        view
        returns (
            uint256,
            uint256,
            uint256
        )
    {
        //generieren der Zufallszahl
        return (
            bet_numbers[msg.sender],
            bet_values[msg.sender],
            block_numbers[msg.sender]
        );
    }
}
