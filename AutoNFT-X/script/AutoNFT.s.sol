pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/AutoNFT.sol";

contract AutoNFTScript is Script {
    function setUp() public {}

    function run() public {
        uint privateKey = vm.envUint("PRIVATE_KEY");
        address owner = vm.addr(privateKey);

        vm.startBroadcast(privateKey);
        console.log("[INFO]: Starting deployment by owner: ", owner);

        AutoNFT autoNFT = new AutoNFT(owner);
        console.log("[INFO]: First AutoNFT deployed. Contract owner: ", owner);

        autoNFT.safeMint(
            owner,
            "AutoNFT",
            "AutoNFT",
            2024,
            "AutoNFT",
            "AutoNFT",
            2024,
            "URI/uri"
        );
        console.log("[INFO]: First AutoNFT-X deployed. NFT owner: ", owner);

        vm.stopBroadcast();
    }
}
