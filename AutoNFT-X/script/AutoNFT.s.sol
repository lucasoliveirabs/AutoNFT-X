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
            "_manufacturer",
            "_model",
            2024,
            "_vin",
            "_color",
            "URI/uri"
        );
        console.log("[INFO]: First AutoNFT-X deployed. NFT owner: ", owner);

        vm.stopBroadcast();
    }
}
