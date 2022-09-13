pragma solidity ^0.6.6;

contract Lottery {
    mapping(address => uint256) public block_numbers;
    mapping(address => uint256) public bet_numbers;

    function place_bet(uint256 bet_number) public payable {
        block_numbers[msg.sender] = block.number;
        bet_numbers[msg.sender] = bet_number;
    }

    function claim() public {}
}
