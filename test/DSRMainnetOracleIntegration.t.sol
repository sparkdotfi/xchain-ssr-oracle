// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.0;

import "forge-std/Test.sol";

import { BridgedDomain, Domain } from "xchain-helpers/testing/BridgedDomain.sol";

import { DSRMainnetOracle, IPot } from "../src/DSRMainnetOracle.sol";

interface IPotDripLike {
    function drip() external;
}

contract DSRMainnetOracleIntegrationTest is Test {

    uint256 constant CURR_DSR          = 1.000000001547125957863212448e27;
    uint256 constant CURR_CHI          = 1.039942074479136064327544607e27;
    uint256 constant CURR_CHI_COMPUTED = 1.039942923989970019616436906e27;
    uint256 constant CURR_RHO          = 1698170603;

    address pot = 0x197E90f9FAD81970bA7976f33CbD77088E5D7cf7;

    DSRMainnetOracle oracle;

    function setUp() public {
        vm.createSelectFork(getChain("mainnet").rpcUrl, 18421823);

        assertEq(IPot(pot).dsr(), CURR_DSR);
        assertEq(IPot(pot).chi(), CURR_CHI);
        assertEq(IPot(pot).rho(), CURR_RHO);

        oracle = new DSRMainnetOracle(address(pot));
    }

    function test_drip_update() public {
        assertEq(oracle.getDSR(), CURR_DSR);
        assertEq(oracle.getChi(), CURR_CHI);
        assertEq(oracle.getRho(), CURR_RHO);

        IPotDripLike(pot).drip();

        assertEq(IPot(pot).dsr(), CURR_DSR);
        assertGt(IPot(pot).chi(), CURR_CHI);
        assertEq(IPot(pot).rho(), block.timestamp);
        
        oracle.refresh();

        assertEq(oracle.getDSR(), CURR_DSR);
        assertEq(oracle.getChi(), CURR_CHI_COMPUTED);
        assertEq(oracle.getRho(), block.timestamp);
    }

}
