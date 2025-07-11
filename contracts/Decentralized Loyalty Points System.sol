// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract LoyaltyPoints {
    address public admin;

    struct Merchant {
        bool isRegistered;
        string name;
    }

    mapping(address => Merchant) public merchants;
    mapping(address => uint256) public pointsBalance;

    event MerchantRegistered(address indexed merchant, string name);
    event PointsIssued(address indexed merchant, address indexed customer, uint256 amount);
    event PointsRedeemed(address indexed customer, uint256 amount);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    modifier onlyMerchant() {
        require(merchants[msg.sender].isRegistered, "Only registered merchants can issue points");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function registerMerchant(address merchant, string calldata name) external onlyAdmin {
        merchants[merchant] = Merchant({isRegistered: true, name: name});
        emit MerchantRegistered(merchant, name);
    }

    function issuePoints(address customer, uint256 amount) external onlyMerchant {
        pointsBalance[customer] += amount;
        emit PointsIssued(msg.sender, customer, amount);
    }

    function redeemPoints(uint256 amount) external {
        require(pointsBalance[msg.sender] >= amount, "Not enough points to redeem");
        pointsBalance[msg.sender] -= amount;
        emit PointsRedeemed(msg.sender, amount);
    }

    function getMyPoints() external view returns (uint256) {
        return pointsBalance[msg.sender];
    }
}

