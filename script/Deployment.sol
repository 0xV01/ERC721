//SPDX-License-Identifier: MIT

pragma solidity 0.8.14;

import "../src/ERC721Contract.sol";
import "forge-std/Script.sol";
import "forge-std/Test.sol";

contract DeployScript is Script {
    function run() external {
        vm.startBroadcast();

        ERC721Contract erc721 = new ERC721Contract();
        //erc721.makeAnEpicNFT();
        //require(erc721._tokenIds() == 1);
        
    }

}