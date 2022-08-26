// SPDX-License-Identifier: MIT

/**
                                                                                                
     ██████╗ ██████╗ ██╗███████╗███████╗██╗███╗   ██╗██╗      █████╗ ███╗   ██╗██████╗ 
    ██╔════╝ ██╔══██╗██║██╔════╝██╔════╝██║████╗  ██║██║     ██╔══██╗████╗  ██║██╔══██╗
    ██║  ███╗██████╔╝██║█████╗  █████╗  ██║██╔██╗ ██║██║     ███████║██╔██╗ ██║██║  ██║
    ██║   ██║██╔══██╗██║██╔══╝  ██╔══╝  ██║██║╚██╗██║██║     ██╔══██║██║╚██╗██║██║  ██║
    ╚██████╔╝██║  ██║██║██║     ██║     ██║██║ ╚████║███████╗██║  ██║██║ ╚████║██████╔╝
    ╚═════╝ ╚═╝  ╚═╝╚═╝╚═╝     ╚═╝     ╚═╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝ 
                                                                                      
      GriffinLand is a blockchain-based Play to Earn PvP and PvE battle game, 
      inspired by mythological characters. There are 6400 NFTs in GriffinLand, 
      consisting of 4 different characters and different rarities.  
      @development by AybeeTech -> lestonz
*/

pragma solidity >=0.8.9 <0.9.0;

// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/ERC1155.sol";
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";


import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract GriffinLand1155Test is ERC1155, Ownable {
    
  string public name;
  string public symbol;

  mapping(uint => string) public tokenURI;
  mapping(uint256 => bool) public burnable;
  uint256[] public tokenIds;
  mapping(uint256 => bool) public added;

  constructor() ERC1155("") {
    name = "GriffinLand1155";
    symbol = "GL1155";
  }

  function mint(address _to, uint _id, uint _amount, bool isBurnable) external onlyOwner {
    burnable[_id] = isBurnable;
    if(added[_id] == false){
      tokenIds.push(_id);
      added[_id] = true;
    }
    _mint(_to, _id, _amount, "");
  }

  function mintBatch(address _to, uint[] memory _ids, uint[] memory _amounts, bool[] memory isBurnable) 
  external onlyOwner {
    for(uint256 i =0; i< isBurnable.length;i++){
      if(added[_ids[i]] == false){
      tokenIds.push(_ids[i]);
      added[_ids[i]] = true;
    }
        burnable[_ids[i]] = isBurnable[i];
    }
    _mintBatch(_to, _ids, _amounts, "");
  }

  function burn(uint _id, uint _amount) external {
    _burn(msg.sender, _id, _amount);
  }

  function burnBatch(uint[] memory _ids, uint[] memory _amounts) external {
    _burnBatch(msg.sender, _ids, _amounts);
  }

  function burnForMint(address _from, uint[] memory _burnIds, uint[] memory _burnAmounts,
  uint[] memory _mintIds, uint[] memory _mintAmounts, bool[] memory isBurnable) external onlyOwner {
    _burnBatch(_from, _burnIds, _burnAmounts);
    for(uint256 i =0; i< isBurnable.length;i++){
        if(added[_mintIds[i]] == false){
         tokenIds.push(_mintIds[i]);
        added[_mintIds[i]] = true;
        }
        burnable[_mintIds[i]] = isBurnable[i];
    }
    _mintBatch(_from, _mintIds, _mintAmounts, "");
  }

  function setURI(uint _id, string memory _uri) external onlyOwner {
    tokenURI[_id] = _uri;
    emit URI(_uri, _id);
  }

  function uri(uint _id) public override view returns (string memory) {
    return tokenURI[_id];
  }

  function getAllTokenIds() external view returns(uint256[] memory){ 
    return(tokenIds);
  }

}
    
