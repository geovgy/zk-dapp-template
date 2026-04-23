// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {Membership} from "../src/Membership.sol";
import {IVerifier} from "../src/verifiers/membership_verifier.sol";

contract HonkVerifierMock is IVerifier {
    function verify(bytes calldata proof, bytes32[] calldata publicInputs) public view returns (bool) {
        return true;
    }
}

contract MembershipTest is Test {
    Membership public membership;

    function setUp() public {
        membership = new Membership(new HonkVerifierMock());
    }

    function test_addLeaf() public {
        membership.addLeaf(1);
        (uint256 root, uint256 size, uint256 depth) = membership.getTree();
        assertEq(root, 1);
        assertEq(size, 1);
        assertEq(depth, 0);
    }

    function test_verifyProof() public {
        membership.addLeaf(1);
        bytes memory proof = bytes("mock proof");
        bool verified = membership.verifyProof(proof);
        assertTrue(verified);
    }
}
