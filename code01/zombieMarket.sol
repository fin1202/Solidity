//SPDX-License-Identifier:MIT
pragma solidity ^0.5.12;

import "./zombieOwnership.sol";

contract ZombieMarket is ZombieOwnership{

    //税金
    uint public tax = 1 finney;
    //最低售价
    uint public minPrice = 1 finney;//0.001 ether = 10的15次方

    //出售构造体
    struct zombieSales {
        //出售者
        address payable seller;
        //售价
        uint price;
    }
    //售出僵尸列表
    mapping(uint => zombieSales) public zombiesShop;
    //出售僵尸事件
    event SaleZombie(uint indexed zombieId,address indexed seller);
    //购买僵尸事件
    event BuyShopZombie(uint indexed zombieId,address indexed buyer,address indexed seller);
    //出售我的僵尸
    function saleMyZombie(uint _zombieId,uint _price) public onlyOwnerOf(_zombieId){
        require(_price >= (tax + minPrice),"price < minPrice");
        zombiesShop[_zombieId] = zombieSales(msg.sender,_price);
        emit SaleZombie(_zombieId,msg.sender);
    }
    //购买市场僵尸
    function buyShopZombie(uint _zombieId) public payable{
        zombieSales memory _zombieSales = zombiesShop[_zombieId];
        require(msg.value >= (_zombieSales.price + tax),"buy price < selle price");
        //转移僵尸
        _transfer(_zombieSales.seller,msg.sender,_zombieId);
       _zombieSales.seller.transfer(msg.value - tax);
        //删除市场在售僵尸
        delete zombiesShop[_zombieId];
        emit BuyShopZombie(_zombieId,msg.sender,_zombieSales.seller);
    }
    //设置税金
    function setTax(uint _tax) public onlyOwner{
        tax = _tax;
    }
    //设置最低出售价
    function setMinPrie(uint _minPrice) public onlyOwner{
        minPrice = _minPrice;
    }
}