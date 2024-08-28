// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.0;

import { OptimismForwarder } from 'xchain-helpers/forwarders/OptimismForwarder.sol';

import { DSROracleForwarderBase } from './DSROracleForwarderBase.sol';

contract DSROracleForwarderOptimism is DSROracleForwarderBase {

    address public immutable l1CrossDomain;

    constructor(address _pot, address _l2Oracle, address _l1CrossDomain) DSROracleForwarderBase(_pot, _l2Oracle) {
        l1CrossDomain = _l1CrossDomain;
    }

    function refresh(uint32 gasLimit) public {
        OptimismForwarder.sendMessageL1toL2(
            l1CrossDomain,
            address(l2Oracle),
            _packMessage(),
            gasLimit
        );
    }

}
