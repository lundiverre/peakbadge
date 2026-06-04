// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
// PeakBadge — On-chain achievement badge system
contract PeakBadge {
    address public owner;
    struct BadgeType { string name; string description; uint256 awarded; bool active; }
    BadgeType[] public badgeTypes;
    mapping(address => mapping(uint256 => bool)) public hasBadge;
    mapping(address => uint256[]) private userBadgeList;
    event BadgeTypeCreated(uint256 indexed typeId, string name);
    event BadgeAwarded(address indexed user, uint256 indexed typeId, string badgeName);
    constructor() { owner = msg.sender; }
    modifier onlyOwner() { require(msg.sender == owner, "Not owner"); _; }
    function createBadgeType(string calldata name, string calldata desc) external onlyOwner returns (uint256) {
        badgeTypes.push(BadgeType(name, desc, 0, true));
        emit BadgeTypeCreated(badgeTypes.length - 1, name);
        return badgeTypes.length - 1;
    }
    function award(address user, uint256 typeId) external onlyOwner {
        require(typeId < badgeTypes.length, "Invalid type");
        require(badgeTypes[typeId].active, "Badge inactive");
        require(!hasBadge[user][typeId], "Already has badge");
        hasBadge[user][typeId] = true;
        userBadgeList[user].push(typeId);
        badgeTypes[typeId].awarded++;
        emit BadgeAwarded(user, typeId, badgeTypes[typeId].name);
    }
    function getBadges(address user) external view returns (uint256[] memory) { return userBadgeList[user]; }
    function badgeCount() external view returns (uint256) { return badgeTypes.length; }

    // ── PUBLIC: anyone can claim or create a badge ───────────────
    event BadgeClaimed(address indexed user, uint256 indexed typeId);
    function claimBadge(uint256 typeId) external returns (bool) {
        require(typeId < badgeTypes.length, "Invalid type");
        require(badgeTypes[typeId].active, "Badge inactive");
        require(!hasBadge[msg.sender][typeId], "Already claimed");
        hasBadge[msg.sender][typeId] = true;
        userBadgeList[msg.sender].push(typeId);
        badgeTypes[typeId].awarded++;
        emit BadgeClaimed(msg.sender, typeId);
        return true;
    }
    function mintBadge(string calldata name, string calldata desc) external returns (uint256) {
        badgeTypes.push(BadgeType(name, desc, 0, true));
        uint256 typeId = badgeTypes.length - 1;
        emit BadgeTypeCreated(typeId, name);
        hasBadge[msg.sender][typeId] = true;
        userBadgeList[msg.sender].push(typeId);
        badgeTypes[typeId].awarded++;
        emit BadgeClaimed(msg.sender, typeId);
        return typeId;
    }

}