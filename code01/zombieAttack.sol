//SPDX-License-Identifier:MIT
pragma solidity ^0.5.12;

import "./zombieHelper.sol";

contract ZombieAttack is ZombieHelper{
    uint randNonce = 0;//随机数种子
    uint attackVictoryProbability = 70;//主动发起攻击胜率
    //获取此次攻击胜率
    function randMod(uint _modulus)internal returns(uint){
        randNonce++;
        return uint(keccak256(abi.encodePacked(block.timestamp,msg.sender,randNonce))) % _modulus;
    }
    //设置发起进攻胜率
    function setAttackVictoryProbability(uint _attackVictoryProbability) public onlyOwner{
        attackVictoryProbability = _attackVictoryProbability;
    }
    //攻击
    function attack(uint _zombieId,uint _targetId) external onlyOwnerOf(_zombieId){
        Zombie storage myZombie = zombies[_zombieId];
        Zombie storage targetZombie = zombies[_targetId];
        uint rand = randMod(100) + 1;
        if(rand <=attackVictoryProbability){
            myZombie.winCount++;
            targetZombie.lossCount++;
            myZombie.level++;
            multiply(_zombieId,_targetId);
        }else{
            myZombie.lossCount++;
            targetZombie.winCount++;
            _triggerColldown(myZombie);
        }
    } 
}