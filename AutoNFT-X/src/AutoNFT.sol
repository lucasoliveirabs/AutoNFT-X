pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";

contract AutoNFT is
    ERC721,
    ERC721URIStorage,
    ERC721Pausable,
    Ownable,
    ERC721Burnable
{
    uint256 private vehicleId;
    mapping(uint256 => Vehicle) private vehicleById;
    mapping(uint256 => address[]) private vehicleOwnershipHistoryById;

    struct Vehicle {
        string manufacturer;
        string model;
        uint16 year;
        string vin;
        string color;
        uint256 kilometerMileage;
        string imageURI;
    }

    constructor(
        address initialOwner
    ) ERC721("AutoNFT-X", "AUTOX") Ownable(initialOwner) {}

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function safeMint(
        address _to,
        string calldata _manufacturer,
        string calldata _model,
        uint16 _year,
        string calldata _vin,
        string calldata _color,
        uint256 _kilometerMileage,
        string calldata _uri
    ) public onlyOwner {
        ++vehicleId;
        _safeMint(_to, vehicleId);
        _setTokenURI(vehicleId, _uri);

        vehicleById[vehicleId] = Vehicle({
            manufacturer: _manufacturer,
            model: _model,
            year: _year,
            vin: _vin,
            color: _color,
            kilometerMileage: _kilometerMileage,
            imageURI: _uri
        });
    }

    function _update(
        address _to,
        uint256 _vehicleId,
        address _auth
    ) internal override(ERC721, ERC721Pausable) returns (address) {
        vehicleOwnershipHistoryById[_vehicleId].push(_to);
        return super._update(_to, _vehicleId, _auth);
    }

    function tokenURI(
        uint256 _vehicleId
    ) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(_vehicleId);
    }

    function supportsInterface(
        bytes4 _interfaceId
    ) public view override(ERC721, ERC721URIStorage) returns (bool) {
        return super.supportsInterface(_interfaceId);
    }

    function getVehicleId() public view returns (uint256) {
        return vehicleId;
    }

    function getVehicleById(uint256 id) public view returns (Vehicle memory) {
        return vehicleById[id];
    }

    function getvehicleOwnershipHistoryById(
        uint256 _vehicleId
    ) public view returns (address[] memory) {
        return vehicleOwnershipHistoryById[_vehicleId];
    }
}
