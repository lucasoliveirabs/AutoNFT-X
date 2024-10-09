// SPDX-License-Identifier: UNLICENSED
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
        console.log(
            "[INFO]: AutoNFT contract deployed. Contract owner: ",
            owner
        );

        autoNFT.safeMint(
            owner,
            "Manufacturer",
            "Model",
            2024,
            "VIN",
            "Color",
            "URI/uri"
        );
        console.log("[INFO]: First AutoNFT-X NFT created. NFT owner: ", owner);

        vm.stopBroadcast();
    }
}
