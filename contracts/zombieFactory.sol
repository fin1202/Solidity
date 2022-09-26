//SPDX-License-Identifier:MIT
pragma solidity ^0.5.12;
import "./ownable.sol";
import "./safemath.sol";

contract zombieFactory is Ownable{
    using SafeMath for uint256;

    uint dnaDigits = 16;//位数
    uint dnaModulus = 10**16;//位数单位
    uint public cooldownTime = 1 days;//冷却时间
    uint public zombiePrice = 0.01 ether;//wei 初始价格

    uint public zombieCount = 0;//初始数量

    struct Zombie{
        string name;
        uint dna;
        uint winCount;
        uint lossCount;
        uint32 level;
        uint32 readyTime;
    }

    Zombie[] public zombies;//所有僵尸

    mapping(uint=>address) public zombieToOwner; //僵尸拥有者
    mapping(address=>uint) ownerZombieCount; //用户拥有的僵尸数量
    mapping(uint => uint) public zombieFeedTimes; //喂食次数

   

    //新生成僵尸
    event NewZombie(uint zombieId,string name,uint dna);

    function _generateRandomDna(string memory _str)private view returns(uint)
    {
        return uint(keccak256(abi.encodePacked(_str,block.timestamp))) % dnaModulus;
    }
    //内部创建僵尸
    function _createZombie(string memory _name,uint _dna) internal{
        zombies.push(Zombie(_name,_dna,0,0,1,0));
        uint id = zombies.length - 1;
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender] = ownerZombieCount[msg.sender].add(1);
        zombieCount = zombieCount.add(1);
        emit NewZombie(id,_name,_dna);
    }
    //外部创建僵尸
    function createZombie(string memory _name) public{
        require(ownerZombieCount[msg.sender]==0,"created");
        uint randDna = _generateRandomDna(_name);
        randDna = randDna - randDna % 10;
        _createZombie(_name,randDna);
    }
    //买僵尸
    function buyZombie(string memory _name) public payable{
        require(ownerZombieCount[msg.sender] > 0,"count <=0");
        require(msg.value >= zombiePrice,"value < zombiePrice");
        uint randDna =_generateRandomDna(_name);
        randDna = randDna - randDna % 10 + 1;
        _createZombie(_name,randDna);
    }
    //设置僵尸价格
    function setZombiePrice(uint _price)external onlyOwner{
        zombiePrice = _price;
    }
}
