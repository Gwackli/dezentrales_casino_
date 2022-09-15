pragma solidity ^0.6.6;

contract Casino {
    mapping(address => uint256) public block_numbers;
    mapping(address => uint256) public bet_numbers;
    mapping(address => uint256) public bet_values;

    uint256 min_value = 1_000_000_000_000_000_000;
    uint256 min_number = 1;
    uint256 max_number = 10;

    function place_bet(uint256 bet_number) public payable {
        require(msg.value >= min_value, "Not enough Matic");
        require(
            bet_number >= min_number && bet_number <= max_number,
            "Number not in range"
        );
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
        return (
            bet_numbers[msg.sender],
            bet_values[msg.sender],
            block_numbers[msg.sender]
        );
    }
}
