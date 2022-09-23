//SPDX-License-Identifier:MIT
pragma solidity ^0.5.12;

import "./zombieMarket.sol";
import "./zombieFeeding.sol";
import "./zombieAttack.sol";

contract ZombieCore is ZombieMarket,ZombieFeeding,ZombieAttack {
    string public constant name = "MyCryptoZombie";
    string public constant symbol = "MCZ";
    //空函数(回退函数)
    function () external payable{}
    //提款函数
    function withdraw() external onlyOwner{
        owner.transfer(address(this).balance);
    }
    //当前合约地址
    function checkBalance() external view onlyOwner returns(uint){
        return address (this).balance;
    }
}