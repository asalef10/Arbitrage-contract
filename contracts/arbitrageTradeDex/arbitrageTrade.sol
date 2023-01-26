// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.8.0;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol";
import "https://github.com/pancakeswap/pancake-smart-contracts/blob/master/projects/exchange-protocol/contracts/interfaces/IPancakeRouter01.sol";

contract arbitrageTrade {
    address public owner;
    uint256 public balance;
    IPancakeRouter01 public pancakeswapRouter;
    IUniswapV2Router01 public uniswapRouter;
    address constant _IRoutesUniswapAddress =
        0xb71c52BA5E0690A7cE3A0214391F4c03F5cbFB0d;
    address constant _IPancakeswapAddress =
        0x7a54bbb93d7982d7c4810e60dbf16974231E6130;
    address WMATIC = 0x9c3C9283D3e44854697Cd22D3Faa240Cfb032889;
    address WETH = 0xA6FA4fB5f76172d178d61B04b0ecd319C5d1C0aa;
    address[] path;

    constructor() public {
        owner = msg.sender;
        pancakeswapRouter = IPancakeRouter01(_IPancakeswapAddress);
        uniswapRouter = IUniswapV2Router01(_IRoutesUniswapAddress);
        path = new address[](2);
        path[0] = WMATIC;
        path[1] = WETH;
    }

    function getAmountOutMinUniswap(uint256 _amount)
        public
        view
        returns (uint256)
    {
        uint256[] memory amountOutMins = uniswapRouter.getAmountsOut(
            _amount,
            path
        );
        return amountOutMins[path.length - 1];
    }

    function getAmountOutMinPancakeswap(uint256 _amount)
        public
        view
        returns (uint256)
    {
        uint256[] memory amountOutMins = pancakeswapRouter.getAmountsOut(
            _amount,
            path
        );
        return amountOutMins[path.length - 1];
    }

    function performArbitrage(uint256 _amount) external {
        uint256 amountOutMinUniswap = getAmountOutMinUniswap(_amount);

        uint256 amountOutMinPancakeswap = getAmountOutMinPancakeswap(_amount);

        uint256 uniswapExchangeRate = amountOutMinUniswap / _amount;

        uint256 pancakeswapExchangeRate = amountOutMinPancakeswap / _amount;

        if (pancakeswapExchangeRate > uniswapExchangeRate) {
            // Buy token1 on Uniswap and sell token
            uniswapRouter.swapExactTokensForTokens(
                _amount,
                10000,
                path,
                msg.sender,
                block.timestamp
            );
            path[0] = WETH;
            path[1] = WMATIC;
            // Sell token1 on pancakeswap and buy token2
            pancakeswapRouter.swapExactTokensForTokens(
                _amount,
                10000,
                path,
                msg.sender,
                block.timestamp
            );
        }
    }

    function getWETH() public view returns (address) {
        return uniswapRouter.WETH();
    }

    function getWETHFromPancswap() public view returns (address) {
        return pancakeswapRouter.WETH();
    }

    function getFactory() public view returns (address) {
        return uniswapRouter.factory();
    }
}












