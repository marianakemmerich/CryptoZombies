pragma solidity >=0.5.0 <0.6.0;

import "./zombiehelper.sol";

contract ZombieAttack is ZombieHelper {
  uint randNonce = 0;
  uint attackVictoryProbability = 70;

  function randMod(uint _modulus) internal returns(uint) {
    randNonce++;
    return uint(keccak256(abi.encodePacked(now, msg.sender, randNonce))) % _modulus;
  }
  
  function attack(uint _zombieId, uint _targetId) external ownerOf(_zombieId) {
    // get pointers to both zombies to easily interact wth them:
    Zombie storage myZombie = zombies[_zombieId];
    Zombie storage enemyZombie = zombies[_targetId];
    uint rand = randMod(100); // determine the outcome of the battle
    if (rand <= attackVictoryProbability) {
      myZombie.winCount++;
      myZombie.level++; // level up!
      enemyZombie.lossCount++; // loser!
      feedAndMultiply(_zombieId, enemyZombie.dna, "zombie");
    }else {
      myZombie.lossCount++;
      enemyZombie.winCount++;
      _triggerCooldown(myZombie); // cooldown will be triggered whether the zombie wins or loses
    }
  }
}  