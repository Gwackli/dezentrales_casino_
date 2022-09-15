pragma solidity ^0.6.6;

contract Casino {
    mapping(address => uint256) public block_numbers;
    mapping(address => uint256) public bet_numbers;
    mapping(address => uint256) public bet_values;

    function place_bet(uint256 bet_number) public payable {
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
