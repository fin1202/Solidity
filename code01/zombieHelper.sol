//SPDX-License-Identifier:MIT
pragma solidity ^0.5.12;

import "./zombieFactory.sol";

contract ZombieHelper is zombieFactory{

    uint levelUpFee = 0.001 ether; //2000000000000000

    modifier aboveLevel(uint _level,uint _zombieId){
        require(zombies[_zombieId].level >= _level,"_level > _zombieId.level");
        _;
    }
    //僵尸是否为当前调用者所有
    modifier onlyOwnerOf(uint _zombieId){
        require(msg.sender == zombieToOwner[_zombieId],"not owner");
        _;
    }
    //设置升级费
    function setLevelUpFee(uint _fee)external onlyOwner{
        levelUpFee = _fee;
    }
    //升级
    function levelUp(uint _zombieId)external payable{
        require(msg.value >= levelUpFee,"msg.value < levelUpFee");
        zombies[_zombieId].level ++;
    }
    //改名
    function changeName(uint _zombieId,string calldata _newName)external aboveLevel(2,_zombieId) onlyOwnerOf(_zombieId){
        zombies[_zombieId].name = _newName;
    }
    //获取该用户拥有的僵尸ID数组
    function getZombiesByOwner(address _owner)external view returns(uint[] memory){
        uint[] memory result = new uint[](ownerZombieCount[_owner]);
        uint counter = 0;
        for(uint i=0;i<zombies.length;i++){
            if(zombieToOwner[i] ==_owner){
                result[counter] = i;
                counter ++;
            }
        }
        return result;
    }
    //冷却事件设置
    function _triggerColldown(Zombie storage _zombie)internal{
        _zombie.readyTime = uint32(block.timestamp + cooldownTime) - uint32((block.timestamp + cooldownTime) % 1 days);
    }
    //是否冷却
    function _isReady(Zombie storage _zombie) internal view returns(bool){
        return (_zombie.readyTime <= block.timestamp);
    }
    //合体
    function multiply(uint _zombieId,uint _targetDna) internal onlyOwnerOf(_zombieId){
        Zombie storage myZombie = zombies[_zombieId];
        require(_isReady(myZombie),"no ready");
        _targetDna  = _targetDna % dnaModulus;//确保是16位
        uint newDna = (myZombie.dna + _targetDna)/2;
        newDna = newDna - newDna % 10;
        _createZombie("NoName",newDna);
        _triggerColldown(myZombie);
    }
}