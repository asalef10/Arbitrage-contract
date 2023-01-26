// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import {FlashLoanSimpleReceiverBase} from "@aave/core-v3/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";
import {IPoolAddressesProvider} from "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";
import "@uniswap/v2-periphery/contracts/interfaces/~IUniswapV2Router01.sol";

contract FlashLoan is FlashLoanSimpleReceiverBase {
    address payable owner;
    address constant _addressProvider_Polygon =
        0x5343b5bA672Ae99d627A1C87866b8E53F47Db2E6;
    address WBTCTestnetMintableERC20Polygon =
        0x85E44420b6137bbc75a85CAB5c9A3371af976FdE;
    address USDTTestnetMintableERC20Polygon =
        0x21C561e551638401b937b03fE5a0a0652B99B7DD;
    address WMATICTestnetMintableERC20Polygon =
        0xb685400156cF3CBE8725958DeAA61436727A30c3;

    constructor()
        FlashLoanSimpleReceiverBase(
            IPoolAddressesProvider(_addressProvider_Polygon)
        )
    {
        owner = payable(msg.sender);
    }

    function executeOperation(
        address asset,
        uint256 amount,
        uint256 premium,
        address initiator,
        bytes calldata params
    ) external override returns (bool) {
    //    logic goes here..
// --

// --
        uint256 amountOwed = amount + premium;
        IERC20(asset).approve(address(POOL), amountOwed);
        return true;
    }

    function requestFlashLoan(address _token, uint256 _amount) public {
        address receiverAddress = address(this);
        address asset = _token;
        uint256 amount = _amount;
        bytes memory params = "";
        uint16 referralCode = 0;

        POOL.flashLoanSimple(
            receiverAddress,
            asset,
            amount,
            params,
            referralCode
        );
    }

    function getBalance(address _tokenAddress) external view returns (uint256) {
        return IERC20(_tokenAddress).balanceOf(address(this));
    }

    function withdraw(address _tokenAddress) external onlyOwner {
        IERC20 token = IERC20(_tokenAddress);
        token.transfer(msg.sender, token.balanceOf(address(this)));
    }

    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "Only the contract owner can call this function"
        );
        _;
    }

    receive() external payable {}
}
