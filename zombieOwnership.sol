//SPDX-License-Identifier:MIT
pragma solidity ^0.5.12;
import "./zombieHelper.sol";
import "./erc721.sol";

contract ZombieOwnership is ZombieHelper,ERC721{

    //批准僵尸至拥有者
    mapping(uint=>address) zombieApprovals;
    //当前用户有多少个僵尸
    function balanceOf(address _owner) public view returns (uint256 _balance){
        return ownerZombieCount[_owner];
    }
    //当前僵尸的用户地址
    function ownerOf(uint256 _tokenId) public view returns (address _owner){
        return zombieToOwner[_tokenId];
    }
    //内部函数
    function _transfer(address _from,address _to, uint256 _tokenId) internal{
        ownerZombieCount[_to] = ownerZombieCount[_to].add(1);
        ownerZombieCount[_from] = ownerZombieCount[_from].sub(1);
        zombieToOwner[_tokenId] = _to;
        emit Transfer(_from,_to,_tokenId);
    }
    //公共转移函数
    function transfer(address _to, uint256 _tokenId) public{
        _transfer(msg.sender,_to,_tokenId);
    }
    //批准僵尸给授权用户
    function approve(address _to, uint256 _tokenId) public{
        zombieApprovals[_tokenId] = _to;
        emit Approval(msg.sender,_to,_tokenId);
    }
    //被授权用户获取僵尸
    function takeOwnership(uint256 _tokenId) public{
        require(zombieApprovals[_tokenId] == msg.sender);
        address owner = ownerOf(_tokenId);
        _transfer(owner,msg.sender,_tokenId);
    }

}