// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.0;

import "forge-std/Test.sol";

import { ISSROracle }                      from "../src/interfaces/ISSROracle.sol";
import { SSRChainlinkRateProviderAdapter } from "../src/adapters/SSRChainlinkRateProviderAdapter.sol";

contract SSROracleMock {

    uint256 public conversionRate;

    constructor(uint256 _conversionRate) {
        conversionRate = _conversionRate;
    }

    function getConversionRate() external view returns (uint256) {
        return conversionRate;
    }

    function setConversionRate(uint256 _conversionRate) external {
        conversionRate = _conversionRate;
    }
    
}

contract SSRChainlinkRateProviderAdapterTest is Test {

    SSROracleMock oracle;

    SSRChainlinkRateProviderAdapter adapter;

    function setUp() public {
        oracle  = new SSROracleMock(1e27);
        adapter = new SSRChainlinkRateProviderAdapter(ISSROracle(address(oracle)));
    }

    function test_constructor() public {
        adapter = new SSRChainlinkRateProviderAdapter(ISSROracle(address(oracle)));
        assertEq(address(adapter.ssrOracle()), address(oracle));
    }

    function test_hardcodedValues() public {
        assertEq(adapter.decimals(),    8);
        assertEq(adapter.description(), "sUSDS / USDS");
        assertEq(adapter.version(),     1);
    }

    function test_conversion() public {
        _assertData(1e8);
        oracle.setConversionRate(1.2e27);
        _assertData(1.2e8);
    }

    function _assertData(int256 value) internal {
        assertEq(adapter.latestAnswer(),    value);
        assertEq(adapter.latestTimestamp(), block.timestamp);
        (uint256 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound) = adapter.latestRoundData();
        assertEq(roundId,         0);
        assertEq(answer,          value);
        assertEq(startedAt,       0);
        assertEq(updatedAt,       block.timestamp);
        assertEq(answeredInRound, 0);
    }

}
