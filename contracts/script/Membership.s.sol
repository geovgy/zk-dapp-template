// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {Membership} from "../src/Membership.sol";
import {HonkVerifier} from "../src/verifiers/membership_verifier.sol";

contract MembershipScript is Script {
    Membership public membership;
    HonkVerifier public verifier;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        verifier = new HonkVerifier();
        membership = new Membership(verifier);

        vm.stopBroadcast();
    }
}
