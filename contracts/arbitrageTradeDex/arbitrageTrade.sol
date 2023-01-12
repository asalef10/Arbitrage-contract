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



















// // SPDX-License-Identifier: MIT
// pragma solidity >=0.5.0 <0.8.0;
// import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
// import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol";
// import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol";
// import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol";
// import "https://github.com/pancakeswap/pancake-smart-contracts/blob/master/projects/exchange-protocol/contracts/libraries/PancakeLibrary.sol";
// import "https://github.com/pancakeswap/pancake-smart-contracts/blob/master/projects/exchange-protocol/contracts/interfaces/IPancakeRouter01.sol";

// contract arbitrageTrade  {
//     address public owner;
//     uint256 public balance;
//     IUniswapV2Factory public uniswapV2Factory;
//     IUniswapV2Pair public uniswapPair;
//     IUniswapV2Router01 public uniswapRouter;
//     IPancakeRouter01 public pancakeswapRouter;

//     address _IUniswapV2PairAddress = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
//     address _IroutesUniswapAddress = 0xf164fC0Ec4E93095b804a4795bBe1e041497b92a;
//     address _IpancakeswapAddress = 0xEfF92A263d31888d860bD50809A8D171709b7b1c;
//     address DAIToken = 0xDF1742fE5b0bFc12331D8EAec6b478DfDbD31464;
//     address USDCToken = 0xA2025B15a1757311bfD68cb14eaeFCc237AF5b43;


//     address[] path;
//     address wrappedEtherToken;
//     address goerliToken;

//     constructor() public {
//         owner = msg.sender;
//         uniswapV2Factory = IUniswapV2Factory(_IUniswapV2PairAddress);
//         uniswapRouter = IUniswapV2Router01(_IroutesUniswapAddress);
//         pancakeswapRouter = IPancakeRouter01(_IpancakeswapAddress);

//         wrappedEtherToken = 0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6;
//         goerliToken = 0x7af963cF6D228E564e2A0aA0DdBF06210B38615D;

//         path = new address[](2);
//         path[0] = USDCToken;
//         path[1] = DAIToken;
//         balance = 0;
//     }

//     function getAmountOutMinUniswap(uint256 _amount)
//         public
//         view
//         returns (uint256)
//     {
//         uint256[] memory amountOutMins = uniswapRouter.getAmountsOut(
//             _amount,
//             path
//         );
//         return amountOutMins[path.length - 1];
//     }

//     function getAmountOutMinPancakeswap(uint256 _amount)
//         public
//         view
//         returns (uint256)
//     {
//         // uint256[] memory amountOutMins = PancakeLibrary.getAmountsOut(_IpancakeswapAddress,_amount, path);
//         // return amountOutMins[path.length -1];
//         // return _amount + 5;
//         return getAmountOutMinUniswap(_amount) - 1;
//     }

//     function performArbitrage(uint256 _amount,address contractAddress) external {
//         uint256 amountOutMinUniswap = getAmountOutMinUniswap(_amount);

//         uint256 amountOutMinPancakeswap = getAmountOutMinPancakeswap(_amount);

//         uint256 uniswapExchangeRate = amountOutMinUniswap / _amount;

//         uint256 pancakeswapExchangeRate = amountOutMinPancakeswap / _amount;

//         balance = getBalance(contractAddress);

//         if (pancakeswapExchangeRate < uniswapExchangeRate) {
//             // Buy token1 on PancakeSwap and sell token
//             IPancakeRouter01(_IpancakeswapAddress).swapExactTokensForTokens(
//                 _amount,
//                 10000,
//                 path,
//                 contractAddress,
//                 block.timestamp
//             );
//             // Sell token1 on Uniswap and buy token2
//             uniswapRouter.swapExactTokensForTokens(
//                 _amount,
//                 10000,
//                 path,
//                 contractAddress,
//                 block.timestamp
//             );
//         }
//     }

//     function setAddress(address addressContract) external {
//         uniswapPair = IUniswapV2Pair(addressContract);
//     }


//     function getOwner() external view returns (address) {
//         return owner;
//     }

//    function getBalance(address contractAddress)public view returns(uint256 balance){
//         return IERC20(USDCToken).balanceOf(contractAddress);
//     }

//     function getName() external view returns (string memory) {
//         return uniswapPair.name();
//     }

//     function getPairs() external view returns (uint256) {
//         return uniswapV2Factory.allPairsLength();
//     }
// }
