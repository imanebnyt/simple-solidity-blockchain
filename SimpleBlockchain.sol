// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract SimpleBlockchain {
    // An array to store the blocks
    Block[] public blocks;
    mapping(address => uint) public minerBalances;
    uint public difficulty;
    uint blockPrice;

    // A struct to represent a block
    struct Block {
        uint index;
        string data;
        bytes32 previousHash;
        bytes32 hash;
        uint timestamp;


    }

    function getBlock(uint _index) public view returns (uint, string memory, uint, bytes32, bytes32) {
        Block storage blockInstance = blocks[_index];
        return (blockInstance.index, blockInstance.data, blockInstance.timestamp, blockInstance.previousHash, blockInstance.hash);
    }

    function getChain() public view returns (Block[] memory) {
        return blocks;
    }

    function mineBlock(string memory _data) public {
        require(msg.sender.balance >= blockPrice, "Not enough ether to mine a block.");
        uint timestamp = block.timestamp;
        bytes32 previousHash;
        if (blocks.length > 0) {
            previousHash = blocks[blocks.length - 1].hash;
        }
        bytes32 nonce = 0x0;
        bytes32 hash;
        uint nonceInt = uint(nonce);
        uint256 hashInt = uint(hash);
        do {
            nonceInt++;
            nonce = bytes32(nonceInt);
            hash = keccak256(abi.encodePacked(_data, previousHash, timestamp, nonce));
            hashInt = uint(hash);
            difficulty++;

        } while (hashInt >= 2**(256-1) / difficulty);
        blocks.push(Block(blocks.length, _data, hash, previousHash, timestamp));
        minerBalances[msg.sender] += blockPrice;
    }

    function getBlockNumber() public view returns (uint) {
        return block.number;
    }

    function getBalance(address _address) public view returns (uint) {
        return address(_address).balance;
    }

    function transfer(address payable _to, uint _amount) public payable returns (bool) {
        require(_to != address(0));
        require(_amount > 0);
        require(address(this).balance > _amount);

        _to.transfer(_amount);
        return true;
    }
}
