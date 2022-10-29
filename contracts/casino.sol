pragma solidity ^0.6.6;

contract Casino {
    //jeweils gesetzte zahl, gewetteter Betrag und den Block speichern in den Variablen
    mapping(address => uint256) public block_numbers;
    mapping(address => uint256) public bet_numbers;
    mapping(address => uint256) public bet_values;

    //definierte Werte
    uint256 min_value = 1_000_000_000_000_000_000;
    uint256 min_number = 1;
    uint256 max_number = 2;
    uint256 range = max_number - min_number + 1;

    //90 von 100 -> 0.9
    uint256 house_edge = 90;

    address private owner;

    constructor() public {
        owner = msg.sender;
    }

    function fill_bank() public payable {}

    function empty_bank(uint256 amount) public {
        require(msg.sender == owner);
        (bool sent, bytes memory data) = owner.call{value: amount}("");
        require(sent, "Failed to send Ether");
    }

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

    function send_win(address winner, uint256 amount) public {
        (bool sent, bytes memory data) = winner.call{value: amount}("");
        require(sent, "Failed to send Ether");
    }

    function claim() public {
        //uperprufen, dass genugend block vergangen sind
        require(
            block_numbers[msg.sender] < block.number,
            "You have to wait for more blocks to pass"
        );

        //generieren der Zufallszahl
        uint256 random_number = (uint256(
            keccak256(
                abi.encodePacked(
                    block.difficulty,
                    block.timestamp,
                    blockhash(block_numbers[msg.sender] + 1)
                )
            )
        ) % range) + min_number;

        //uberprufen ob gewonnen
        //require(random_number == bet_numbers[msg.sender], "You didn't win");

        //auszahlen
        send_win(
            msg.sender,
            ((bet_values[msg.sender] * range * house_edge)) / 100
        );
    }
}
