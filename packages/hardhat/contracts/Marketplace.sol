// SPDX-License-Identifier: MIT

// Version of Solidity compiler this program was written for
pragma solidity >=0.7.0 <0.9.0;

/**
 * @dev Interface for the ERC20 token, in this case cEURToken.
 */
interface IERC20Token {
    // Transfers tokens from one address to another
    function transfer(address, uint256) external returns (bool);

    // Approves a transfer of tokens from one address to another
    function approve(address, uint256) external returns (bool);

    // Transfers tokens from one address to another, with the permission of the first address
    function transferFrom(address, address, uint256) external returns (bool);

    // Returns the total supply of tokens
    function totalSupply() external view returns (uint256);

    // Returns the balance of tokens for a given address
    function balanceOf(address) external view returns (uint256);

    // Returns the amount of tokens that an address is allowed to transfer from another address
    function allowance(address, address) external view returns (uint256);

    // Event for token transfers
    event Transfer(address indexed from, address indexed to, uint256 value);
    // Event for approvals of token transfers
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

/**
 * @title Marketplace Contract
 * @dev A decentralized marketplace contract for buying and selling products using ERC20 tokens.
 */
contract Marketplace {
    // Keeps track of the number of products in the marketplace
    uint256 internal productsLength = 0;
    // Address of the cEURToken
    address internal cEURTokenAddress = 0x10c892A6EC43a53E45D0B916B4b7D383B1b78C0F;

    /**
     * @dev Structure for a product in the marketplace.
     */
    struct Product {
        // Address of the product owner
        address payable owner;
        // Name of the product
        string name;
        // Link to an image of the product
        string image;
        // Description of the product
        string description;
        // Location of the product
        string location;
        // Price of the product in tokens
        uint256 price;
        // Number of times the product has been sold
        uint256 sold;
    }

    /**
     * @dev Emitted when a product is successfully purchased from the marketplace.
     * @param buyer Address of the buyer who purchased the product.
     * @param productIndex Index of the product that was purchased.
     * @param quantity The quantity of the product purchased.
     */
    event ProductPurchased(address indexed buyer, uint256 indexed productIndex, uint256 quantity);

    /**
     * @dev Emitted when a product is removed from the marketplace.
     * @param owner Address of the owner who removed the product.
     * @param productIndex Index of the product that was removed.
     */
    event ProductRemoved(address indexed owner, uint256 indexed productIndex);

    /**
     * @dev Emitted when the price of a product in the marketplace is updated.
     * @param owner Address of the owner who updated the product.
     * @param productIndex Index of the product that was updated.
     * @param newPrice The new price of the product after the update.
     */
    event ProductUpdated(address indexed owner, uint256 indexed productIndex, uint256 newPrice);

    /**
     * @dev Emitted when a new product is added to the marketplace.
     * @param owner Address of the owner who added the product.
     * @param productIndex Index of the product that was added.
     * @param name Name of the new product.
     * @param image Link to the image of the new product.
     * @param description Description of the new product.
     * @param location Location information of the new product.
     * @param price Price of the new product.
     */
    event ProductAdded(
        address indexed owner,
        uint256 indexed productIndex,
        string name,
        string image,
        string description,
        string location,
        uint256 price
    );


    /**
     * @dev Mapping of products to their index.
     * The key is the product index, and the value is a struct representing the product details.
     */
    mapping(uint256 => Product) internal products;
    
    /**
     * @dev Mapping containing the number of times an item is bought by a user.
     * The outer mapping uses the user's address as the key, and the inner mapping uses the product index as the key.
     * The value is the count of how many times the user has bought the corresponding product.
     */
    mapping(address => mapping(uint256 => uint256)) internal userItemsCount;
    
    /**
     * @dev Mapping containing the items bought by a user.
     * The key is the user's address, and the value is an array of product indices representing the items bought by the user.
     */
    mapping(address => uint256[]) internal userItems;


    /**
     * @dev Modifier to check if the caller is the owner of a product.
     * @param _index Index of the product.
     * @param caller Address of the caller.
     */
    modifier isOwner(uint _index, address caller) {
        require(products[_index].owner == caller, "not owner");
        _;
    }

    /**
     * @dev Modifier to check if the product index is valid.
     * @param _index Index of the product.
     */
    modifier isValidProductIndex(uint256 _index) {
        require(_index < productsLength, "Invalid product index");
        _;
    }

    /**
     * @dev Writes a new product to the marketplace.
     * @param _name Name of the product.
     * @param _image Link to an image of the product.
     * @param _description Description of the product.
     * @param _location Location of the product.
     * @param _price Price of the product in tokens.
     */
    function writeProduct(
        string memory _name,
        string memory _image,
        string memory _description,
        string memory _location,
        uint256 _price
    ) public {
        // Add check to ensure that price of product is greater than 0
        require(_price > 0, "Price must be greater than 0");
        // Add checks to ensure that other input parameters are not empty
        require(bytes(_name).length > 0, "Name must not be empty");
        require(bytes(_image).length > 0, "Image link must not be empty");
        require(bytes(_description).length > 0, "Description must not be empty");
        require(bytes(_location).length > 0, "Location must not be empty");
        // Number of times the product has been sold is initially 0 because it has not been sold yet
        uint256 _sold = 0;
        // Adds a new Product struct to the products mapping
        products[productsLength] = Product(
            // Sender's address is set as the owner
            payable(msg.sender),
            _name,
            _image,
            _description,
            _location,
            _price,
            _sold
        );
        // Increases the number of products in the marketplace by 1
        productsLength++;
        emit ProductAdded(
            msg.sender,
            productsLength - 1,
            _name,
            _image,
            _description,
            _location,
            _price
        );
        
    }

    /**
     * @dev Reads a product from the marketplace.
     * @param _index Index of the product.
     * @return owner Address of the product owner.
     * @return name Name of the product.
     * @return image Link to an image of the product.
     * @return description Description of the product.
     * @return location Location of the product.
     * @return price Price of the product in tokens.
     * @return sold Number of times the product has been sold.
     */
    function readProduct(uint256 _index)
        public
        view
        isValidProductIndex(_index)
        returns (
            address payable owner,
            string memory name,
            string memory image,
            string memory description,
            string memory location,
            uint256 price,
            uint256 sold
        )
    {
        // Validate that the index is within the valid range
        require(_index < productsLength, "Invalid product index");

        // Retrieve product details
        Product memory product = products[_index];

        // Check string lengths to ensure they are not empty
        require(bytes(product.name).length > 0, "Product name is empty");
        require(bytes(product.image).length > 0, "Product image link is empty");
        require(bytes(product.description).length > 0, "Product description is empty");
        require(bytes(product.location).length > 0, "Product location is empty");

        // Return product details
        return (
            product.owner,
            product.name,
            product.image,
            product.description,
            product.location,
            product.price,
            product.sold
        );
    }


    /**
     * @dev Buys a product from the marketplace.
     * @param _index Index of the product.
     */
    function buyProduct(
        // Index of the product
        uint256 _index
    ) public isValidProductIndex(_index) payable {        
        uint256 _totalAmount = products[_index].price;
        // transfer amount
        require(
            IERC20Token(cEURTokenAddress).transferFrom(
                // Sender's address is the buyer
                msg.sender,
                // Receiver's address is the contract
                address(this),
                // Amount of tokens to transfer is the total amount of order
                _totalAmount
            ),
            // If transfer fails, throw an error message
            "Transfer failed."
        );

        // Increase the number of times the product has been sold
        products[_index].sold++;

        // Check if item does not exist in useritems and add item to user array
        if (userItemsCount[msg.sender][_index] == 0) {
            userItems[msg.sender].push(_index);
        }

        // Update item count
        userItemsCount[msg.sender][_index]++;
        // Inside the buyProduct function
       emit ProductPurchased(msg.sender, _index, 1);
    }

    /**
     * @dev Get user items array.
     * @param _user Address of the user.
     * @return An array of product indices owned by the user.
     */
    function getUserItem(address _user) public view returns (uint256[] memory){
        return userItems[_user];
    }

    /**
     * @dev Get user items count.
     * @param _user Address of the user.
     * @param _index Index of the product.
     * @return The number of times the user has bought the specified product.
     */
    function getUserItemsCount(address _user, uint256 _index) public view isValidProductIndex(_index) returns (uint256){
        return userItemsCount[_user][_index];
    }

    /**
     * @dev Remove a product from the marketplace.
     * @param _indexToRemove Index of the product to remove.
     */
    function removeProduct(
        uint _indexToRemove
    ) public isValidProductIndex(_indexToRemove) isOwner(_indexToRemove, msg.sender) {
        delete (products[_indexToRemove]);
        emit ProductRemoved(msg.sender, _indexToRemove);
    }

    /**
     * @dev Update pricing of a product from the marketplace.
     * @param _indexToUpdate Index of the product to update.
     * @param _newPrice New price of the product.
     */
    function updateProduct(
        uint _indexToUpdate,
        uint _newPrice
    ) public isValidProductIndex(_indexToUpdate) isOwner(_indexToUpdate, msg.sender) {
        products[_indexToUpdate].price = _newPrice;
        emit ProductUpdated(msg.sender, _indexToUpdate, _newPrice);
    }

    /**
     * @dev Returns the number of products in the marketplace.
     * @return The total number of products.
     */
    function getProductsLength() public view returns (uint256) {
        return (productsLength);
    }

}
