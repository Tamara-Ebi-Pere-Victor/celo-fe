// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol"; // Import Ownable from OpenZeppelin
import "@openzeppelin/contracts/token/ERC20/IERC20.sol"; // Import ERC20 interface from OpenZeppelin

contract Marketplace is Ownable {
    uint256 internal productsLength = 0;
    address internal cEURTokenAddress = 0x10c892A6EC43a53E45D0B916B4b7D383B1b78C0F;

    struct Product {
        address payable owner;
        string name;
        string image;
        string description;
        string location;
        uint256 price;
        uint256 sold;
        bool active; // New field to mark product as active or inactive
    }

    mapping(uint256 => Product) internal products;
    mapping(address => mapping(uint256 => uint256)) internal userItemsCount;
    mapping(address => uint256[]) internal userItems;

    modifier isProductOwner(uint256 _index) {
        require(products[_index].owner == msg.sender, "Not the owner");
        _;
    }

    modifier productExists(uint256 _index) {
        require(products[_index].active, "Product does not exist");
        _;
    }

    function writeProduct(
        string memory _name,
        string memory _image,
        string memory _description,
        string memory _location,
        uint256 _price
    ) public {
        require(_price > 0, "Price must be greater than 0");
        uint256 _sold = 0;
        products[productsLength] = Product(
            payable(msg.sender),
            _name,
            _image,
            _description,
            _location,
            _price,
            _sold,
            true // Set product as active
        );
        productsLength++;
    }

    function readProduct(uint256 _index)
        public
        view
        productExists(_index)
        returns (
            address payable,
            string memory,
            string memory,
            string memory,
            string memory,
            uint256,
            uint256
        )
    {
        return (
            products[_index].owner,
            products[_index].name,
            products[_index].image,
            products[_index].description,
            products[_index].location,
            products[_index].price,
            products[_index].sold
        );
    }

    function buyProduct(uint256 _index) public payable productExists(_index) {
        uint256 _totalAmount = products[_index].price;
        require(
            IERC20(cEURTokenAddress).transferFrom(
                msg.sender,
                address(this),
                _totalAmount
            ),
            "Transfer failed."
        );

        products[_index].sold++;
        if (userItemsCount[msg.sender][_index] == 0) {
            userItems[msg.sender].push(_index);
        }
        userItemsCount[msg.sender][_index]++;
    }

    function getUserItem(address _user)
        public
        view
        returns (uint256[] memory)
    {
        return userItems[_user];
    }

    function getUserItemsCount(address _user, uint256 _index)
        public
        view
        returns (uint256)
    {
        return userItemsCount[_user][_index];
    }

    function removeProduct(uint256 _indexToRemove)
        public
        isProductOwner(_indexToRemove)
        productExists(_indexToRemove)
    {
        products[_indexToRemove].active = false; // Mark product as inactive
    }

    function updateProduct(uint256 _indexToUpdate, uint256 _newPrice)
        public
        isProductOwner(_indexToUpdate)
        productExists(_indexToUpdate)
    {
        products[_indexToUpdate].price = _newPrice;
    }

    function getProductsLength() public view returns (uint256) {
        return (productsLength);
    }
}
