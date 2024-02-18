// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "src/pools/BPTOracle.sol";
import "src/PriceFeed.sol";

import "./setup.t.sol";

import "forge-std/console.sol";

contract BPTOracleTest is SetupTest {
    uint256 mainnetFork;
    BPTOracle public bptPrice;

    function setUp() public override {
        mainnetFork = vm.createFork("https://eth.llamarpc.com");
        vm.selectFork(mainnetFork);
        super.setUp();
        console.log(address(registryContract));
        bptPrice = new BPTOracle(address(registryContract));

        // USDC
        oracle.addPriceFeed(
            address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48),
            address(0x8fFfFfd4AfB6115b954Bd326cbe7B4BA576818f6)
        );

        // WETH
        oracle.addPriceFeed(
            address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2),
            address(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419)
        );

        // DAI
        oracle.addPriceFeed(
            address(0x6B175474E89094C44Da98b954EedeAC495271d0F),
            address(0xAed0c38402a5d19df6E4c03F4E2DceD6e29c1ee9)
        );

        // USDT
        oracle.addPriceFeed(
            address(0xdAC17F958D2ee523a2206206994597C13D831ec7),
            address(0x3E7d1eAB13ad0104d2750B8863b489D65364e32D)
        );

        // rETH (considering 1rETH = 1ETH) - We should use the real rETH price feed (which is in rETH/ETH)
        oracle.addPriceFeed(
            address(0xae78736Cd615f374D3085123A210448E74Fc6393),
            address(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419)
        );

        // vETH (considering 1vETH = 1ETH)
        oracle.addPriceFeed(
            address(0x4Bc3263Eb5bb2Ef7Ad9aB6FB68be80E43b43801F),
            address(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419)
        );

        // uniETH (considering 1vETH = 1ETH)
        oracle.addPriceFeed(
            address(0xF1376bceF0f78459C0Ed0ba5ddce976F1ddF51F4),
            address(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419)
        );

        // wBTC
        oracle.addPriceFeed(
            address(0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599),
            address(0xF4030086522a5bEEa4988F8cA5B36dbC97BeE88c)
        );

        // BAL
        oracle.addPriceFeed(
            address(0xba100000625a3754423978a60c9317c58a424e3D),
            address(0xdF2917806E30300537aEB49A7663062F4d1F2b5F)
        );

        // MKR
        oracle.addPriceFeed(
            address(0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2),
            address(0xec1D1B3b0443256cc3860e24a46F108e699484Aa)
        );

        // STG
        oracle.addPriceFeed(
            address(0xAf5191B0De278C7286d6C7CC6ab6BB8A73bA2Cd6),
            address(0x7A9f34a0Aa917D438e9b6E630067062B7F8f6f3d)
        );

        bptPrice.setHeartbeat(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, 86_400);
        bptPrice.setHeartbeat(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2, 86_400);
        bptPrice.setHeartbeat(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419, 86_400);
        bptPrice.setHeartbeat(0x6B175474E89094C44Da98b954EedeAC495271d0F, 86_400);
        bptPrice.setHeartbeat(0xdAC17F958D2ee523a2206206994597C13D831ec7, 86_400);
        bptPrice.setHeartbeat(0xae78736Cd615f374D3085123A210448E74Fc6393, 86_400);
        bptPrice.setHeartbeat(0x4Bc3263Eb5bb2Ef7Ad9aB6FB68be80E43b43801F, 86_400);
        bptPrice.setHeartbeat(0xF1376bceF0f78459C0Ed0ba5ddce976F1ddF51F4, 86_400);
        bptPrice.setHeartbeat(0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599, 86_400);
        bptPrice.setHeartbeat(0xba100000625a3754423978a60c9317c58a424e3D, 86_400);
        bptPrice.setHeartbeat(0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2, 86_400);
        bptPrice.setHeartbeat(0xAf5191B0De278C7286d6C7CC6ab6BB8A73bA2Cd6, 86_400);
    }

    function testAddPriceFeed() public {
        oracle.addPriceFeed(address(this), address(0xF4030086522a5bEEa4988F8cA5B36dbC97BeE88c));
        (uint80 roundID, int256 price) =
            oracle.LatestAssetPrice(IOracle(0xF4030086522a5bEEa4988F8cA5B36dbC97BeE88c));
        assertFalse(roundID == 0);
        assertFalse(price == 0);
    }

    function testAddPriceFeedAndGetPriceWeETH() public {
        oracle.addPriceFeed(address(this), address(0xdDb6F90fFb4d3257dd666b69178e5B3c5Bf41136));
        (uint80 roundID, int256 price) =
            oracle.LatestAssetPrice(IOracle(0xdDb6F90fFb4d3257dd666b69178e5B3c5Bf41136));
        console.log(uint256(price));
        assertFalse(roundID == 0);
        assertFalse(price == 0);
    }

    /* 
      Weighted Pools
     */

    // https://app.apy.vision/pools/balancerv2_eth-USDC-WETH-0x96646936b91d6b9d7d0c47c496afbf3d6ec7b6f8
    function testBptWeightOnUsdcWethPool() public {
        uint256 amount = bptPrice.BptPriceWeightPool(
            bytes32(0x96646936b91d6b9d7d0c47c496afbf3d6ec7b6f8000200000000000000000019)
        );
        console.log("Weighted USDC wETH pool: ", amount);
        assertFalse(amount == 0);
    }

    // https://app.apy.vision/pools/balancerv2_eth-BAL-WETH-0x5c6ee304399dbdb9c8ef030ab642b10820db8f56
    function testBptWeightOnBalWethPool() public {
        uint256 amount = bptPrice.BptPriceWeightPool(
            bytes32(0x5c6ee304399dbdb9c8ef030ab642b10820db8f56000200000000000000000014)
        );
        console.log("Weighted BAL wETH pool: ", amount);
        assertFalse(amount == 0);
    }

    // https://app.apy.vision/pools/balancerv2_eth-USDC-STG-0x3ff3a210e57cfe679d9ad1e9ba6453a716c56a2e
    function testBptWeightOnStgUsdcPool() public {
        uint256 amount = bptPrice.BptPriceWeightPool(
            bytes32(0x3ff3a210e57cfe679d9ad1e9ba6453a716c56a2e0002000000000000000005d5)
        );
        console.log("Weighted STG USDC pool: ", amount);
        assertFalse(amount == 0);
    }

    // https://app.apy.vision/pools/balancerv2_eth--WETH-0xaac98ee71d4f8a156b6abaa6844cdb7789d086ce
    function testBptWeightOnMkrWethPool() public {
        uint256 amount = bptPrice.BptPriceWeightPool(
            bytes32(0xaac98ee71d4f8a156b6abaa6844cdb7789d086ce00020000000000000000001b)
        );
        console.log("Weighted MKR wETH pool: ", amount);
        assertFalse(amount == 0);
    }

    /* 
      Stable Pools
     */
    // https://app.apy.vision/pools/balancerv2_eth-DAI-USDC-USDT-0x06df3b2bbb68adc8b0e302443692037ed9f91b42
    function testBptStableOnDaiUsdcUsdtPool() public {
        uint256 amount = bptPrice.BptPriceStablePool(
            bytes32(0x06df3b2bbb68adc8b0e302443692037ed9f91b42000000000000000000000063)
        );
        console.log("Stable DAI USDC USDT pool: ", amount);
        assertFalse(amount == 0);
    }

    // https://app.apy.vision/pools/balancerv2_eth-vETH-WETH-0x156c02f3f7fef64a3a9d80ccf7085f23cce91d76
    function testBptStableOnVethWethPool() public {
        uint256 amount = bptPrice.BptPriceStablePool(
            bytes32(0x156c02f3f7fef64a3a9d80ccf7085f23cce91d76000000000000000000000570)
        );
        console.log("Stable vETH wETH pool: ", amount);
        assertFalse(amount == 0);
    }

    /* 
      Composable Pools
     */
    // https://app.apy.vision/pools/balancerv2_eth-DAI-USDC-USDT-0x79c58f70905f734641735bc61e45c19dd9ad60bc
    function testBptComposableStableOnDaiUsdcUsdtPool() public {
        uint256 amount = bptPrice.BptPriceStablePool(
            bytes32(0x79c58f70905f734641735bc61e45c19dd9ad60bc0000000000000000000004e7)
        );
        console.log("Composable Stable DAI USDC USDT pool: ", amount);
        assertFalse(amount == 0);
    }

    // https://app.apy.vision/pools/balancerv2_eth-WETH-uniETH-0xbfce47224b4a938865e3e2727dc34e0faa5b1d82
    function testBptComposableStableOnWethUniEthPool() public {
        uint256 amount = bptPrice.BptPriceStablePool(
            bytes32(0xbfce47224b4a938865e3e2727dc34e0faa5b1d82000000000000000000000527)
        );
        console.log("Composable Stable wETH uniETH pool: ", amount);
        assertFalse(amount == 0);
    }
}
