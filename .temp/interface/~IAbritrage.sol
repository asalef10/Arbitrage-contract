interface IAbritrage {
    function performArbitrage(uint256 _amount) external;
    function getOwner() external view returns (address);
}
