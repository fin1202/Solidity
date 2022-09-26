pragma solidity >=0.4.21 <0.6.0;

contract Migrations {

  address public owner;
  uint public last_completed_migration;

  constructor() public {
    owner = msg.sender;
  }
  //限制
  modifier restricted() {
    if (msg.sender == owner)
    _;
  }
  //设置完成
  function setCompleted(uint completed) public restricted {
    last_completed_migration = completed;
  }
  //升级
  function upgrade(address new_address) public restricted {
    Migrations upgraded = Migrations(new_address);
    upgraded.setCompleted(last_completed_migration);
  }
}