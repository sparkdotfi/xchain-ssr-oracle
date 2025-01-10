// SPDX-License-Identifier: AGPL-3.0
pragma solidity ^0.8.0;

import { ISSROracle } from "../interfaces/ISSROracle.sol";

/**
 * @title  SSRChainlinkRateProviderAdapter
 * @notice A thin adapter which gives an up-to-date SSR conversion price in Chainlink format.
 */
contract SSRChainlinkRateProviderAdapter {

    ISSROracle public immutable ssrOracle;

    constructor(ISSROracle _ssrOracle) {
        ssrOracle = _ssrOracle;
    }

    function latestAnswer() external view returns (int256) {
        // Note: Cannot overflow due to division
        return int256(ssrOracle.getConversionRate() / 1e19);
    }

    function latestTimestamp() external view returns (uint256) {
        return block.timestamp;
    }

    function decimals() external pure returns (uint8) {
        return 8;
    }

    function description() external pure returns (string memory) {
        return "sUSDS / USDS";
    }

    function version() external pure returns (uint256) {
        return 1;
    }

    function latestRoundData()
        external
        view
        returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound)
    {
        return (
            0,
            int256(ssrOracle.getConversionRate() / 1e19),
            0,
            block.timestamp,
            0
        );
    }

}
