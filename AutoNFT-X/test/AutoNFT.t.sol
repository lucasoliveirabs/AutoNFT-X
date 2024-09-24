pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import "../src/AutoNFT.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";

contract AutoNFTTest is Test {
    AutoNFT autoNFTContract;

    function setUp() public {
        autoNFTContract = new AutoNFT(
            0xFE3B557E8Fb62b89F4916B721be55cEb828dBd73
        );
    }

    function testSafeMint() public {
        //  First mint()
        vm.prank(0xFE3B557E8Fb62b89F4916B721be55cEb828dBd73); //owner
        autoNFTContract.safeMint(
            address(1),
            "Ford",
            "Ka",
            2022,
            "121222",
            "gray",
            1222,
            "URI/uri"
        );

        assertEq(autoNFTContract.getVehicleId(), 1);

        address[] memory history = autoNFTContract
            .getvehicleOwnershipHistoryById(1);
        assertEq(history.length, 1);
        assertEq(history[0], address(1));

        AutoNFT.Vehicle memory vehicle = autoNFTContract.getVehicleById(1);
        assertEq(vehicle.manufacturer, "Ford");
        assertEq(vehicle.model, "Ka");
        assertEq(vehicle.year, 2022);
        assertEq(vehicle.vin, "121222");
        assertEq(vehicle.color, "gray");
        assertEq(vehicle.kilometerMileage, 1222);
        assertEq(vehicle.imageURI, "URI/uri");

        //  Second mint()
        vm.prank(0xFE3B557E8Fb62b89F4916B721be55cEb828dBd73); //owner
        autoNFTContract.safeMint(
            address(1),
            "BYD",
            "Dolphin",
            2024,
            "11",
            "black",
            12,
            "URI/uri/2"
        );

        assertEq(autoNFTContract.getVehicleId(), 2);

        history = autoNFTContract.getvehicleOwnershipHistoryById(2);

        assertEq(history.length, 1);
        assertEq(history[0], address(1));

        vehicle = autoNFTContract.getVehicleById(2);
        assertEq(vehicle.manufacturer, "BYD");
        assertEq(vehicle.model, "Dolphin");
        assertEq(vehicle.year, 2024);
        assertEq(vehicle.vin, "11");
        assertEq(vehicle.color, "black");
        assertEq(vehicle.kilometerMileage, 12);
        assertEq(vehicle.imageURI, "URI/uri/2");

        //  Third mint()
        vm.prank(0xFE3B557E8Fb62b89F4916B721be55cEb828dBd73); //owner
        autoNFTContract.safeMint(
            0xFE3B557E8Fb62b89F4916B721be55cEb828dBd73,
            "Renault",
            "Clio",
            2010,
            "100",
            "white",
            100,
            "URI/uri/3"
        );

        assertEq(autoNFTContract.getVehicleId(), 3);

        history = autoNFTContract.getvehicleOwnershipHistoryById(3);
        assertEq(history.length, 1);
        assertEq(history[0], 0xFE3B557E8Fb62b89F4916B721be55cEb828dBd73);

        vehicle = autoNFTContract.getVehicleById(3);
        assertEq(vehicle.manufacturer, "Renault");
        assertEq(vehicle.model, "Clio");
        assertEq(vehicle.year, 2010);
        assertEq(vehicle.vin, "100");
        assertEq(vehicle.color, "white");
        assertEq(vehicle.kilometerMileage, 100);
        assertEq(vehicle.imageURI, "URI/uri/3");
    }

    function testSafeTransferFrom() public {
        //  First transfer - NFT1
        vm.prank(0xFE3B557E8Fb62b89F4916B721be55cEb828dBd73);
        autoNFTContract.safeMint(
            address(1),
            "Ford",
            "Ka",
            2022,
            "121222",
            "gray",
            1222,
            "URI/uri"
        );
        assertEq(autoNFTContract.getVehicleId(), 1);

        vm.prank(address(1));
        autoNFTContract.safeTransferFrom(
            address(1),
            0xFE3B557E8Fb62b89F4916B721be55cEb828dBd73,
            1
        );
        address[] memory history = autoNFTContract
            .getvehicleOwnershipHistoryById(1);
        assertEq(history[0], address(1));
        assertEq(history[1], 0xFE3B557E8Fb62b89F4916B721be55cEb828dBd73);

        //  Second transfer - NFT1
        vm.prank(0xFE3B557E8Fb62b89F4916B721be55cEb828dBd73);
        autoNFTContract.safeTransferFrom(
            0xFE3B557E8Fb62b89F4916B721be55cEb828dBd73,
            address(1),
            1
        );
        history = autoNFTContract.getvehicleOwnershipHistoryById(1);
        assertEq(history[0], address(1));
        assertEq(history[1], 0xFE3B557E8Fb62b89F4916B721be55cEb828dBd73);
        assertEq(history[2], address(1));

        //  Third transfer - NFT1
        vm.prank(address(1));
        autoNFTContract.safeTransferFrom(
            address(1),
            0xC89d705104aFff28245e58C05AcfC82f91F2aEe9,
            1
        );
        history = autoNFTContract.getvehicleOwnershipHistoryById(1);
        assertEq(history[0], address(1));
        assertEq(history[1], 0xFE3B557E8Fb62b89F4916B721be55cEb828dBd73);
        assertEq(history[2], address(1));
        assertEq(history[3], 0xC89d705104aFff28245e58C05AcfC82f91F2aEe9);

        //  Fourth transfer - NFT2
        vm.prank(0xFE3B557E8Fb62b89F4916B721be55cEb828dBd73);
        autoNFTContract.safeMint(
            address(1),
            "BYD",
            "Dolphin",
            2024,
            "11",
            "black",
            12,
            "URI/uri/2"
        );
        assertEq(autoNFTContract.getVehicleId(), 2);

        vm.prank(address(1));
        autoNFTContract.safeTransferFrom(
            address(1),
            0xFE3B557E8Fb62b89F4916B721be55cEb828dBd73,
            2
        );
        history = autoNFTContract.getvehicleOwnershipHistoryById(2);
        assertEq(history[0], address(1));
        assertEq(history[1], 0xFE3B557E8Fb62b89F4916B721be55cEb828dBd73);

        //  Fifth transfer - NFT2
        vm.prank(0xFE3B557E8Fb62b89F4916B721be55cEb828dBd73);
        autoNFTContract.safeTransferFrom(
            0xFE3B557E8Fb62b89F4916B721be55cEb828dBd73,
            0xC89d705104aFff28245e58C05AcfC82f91F2aEe9,
            2
        );
        history = autoNFTContract.getvehicleOwnershipHistoryById(2);
        assertEq(history[0], address(1));
        assertEq(history[1], 0xFE3B557E8Fb62b89F4916B721be55cEb828dBd73);
        assertEq(history[2], 0xC89d705104aFff28245e58C05AcfC82f91F2aEe9);
    }

    function testBurn() public {
        //  First burn()
        vm.prank(0xFE3B557E8Fb62b89F4916B721be55cEb828dBd73); //owner
        autoNFTContract.safeMint(
            address(1),
            "Ford",
            "Ka",
            2022,
            "121222",
            "gray",
            1222,
            "URI/uri"
        );
        assertEq(autoNFTContract.getVehicleId(), 1);

        vm.prank(address(1));
        autoNFTContract.burn(1);

        address[] memory history = autoNFTContract
            .getvehicleOwnershipHistoryById(1);
        assertEq(history[0], address(1));
        assertEq(history[1], address(0));

        //  Second burn()
        vm.prank(0xFE3B557E8Fb62b89F4916B721be55cEb828dBd73);
        autoNFTContract.safeMint(
            address(1),
            "BYD",
            "Dolphin",
            2024,
            "11",
            "black",
            12,
            "URI/uri/2"
        );
        assertEq(autoNFTContract.getVehicleId(), 2);

        vm.prank(address(1));
        autoNFTContract.safeTransferFrom(
            address(1),
            0xFE3B557E8Fb62b89F4916B721be55cEb828dBd73,
            2
        );
        history = autoNFTContract.getvehicleOwnershipHistoryById(2);
        assertEq(history[0], address(1));
        assertEq(history[1], 0xFE3B557E8Fb62b89F4916B721be55cEb828dBd73);

        vm.prank(0xFE3B557E8Fb62b89F4916B721be55cEb828dBd73);
        autoNFTContract.safeTransferFrom(
            0xFE3B557E8Fb62b89F4916B721be55cEb828dBd73,
            0xC89d705104aFff28245e58C05AcfC82f91F2aEe9,
            2
        );
        history = autoNFTContract.getvehicleOwnershipHistoryById(2);
        assertEq(history[0], address(1));
        assertEq(history[1], 0xFE3B557E8Fb62b89F4916B721be55cEb828dBd73);
        assertEq(history[2], 0xC89d705104aFff28245e58C05AcfC82f91F2aEe9);

        vm.prank(0xC89d705104aFff28245e58C05AcfC82f91F2aEe9);
        autoNFTContract.burn(2);
        history = autoNFTContract.getvehicleOwnershipHistoryById(2);
        assertEq(history[0], address(1));
        assertEq(history[1], 0xFE3B557E8Fb62b89F4916B721be55cEb828dBd73);
        assertEq(history[2], 0xC89d705104aFff28245e58C05AcfC82f91F2aEe9);
        assertEq(history[3], address(0));
    }
}
