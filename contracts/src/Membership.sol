// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {IVerifier} from "./verifiers/membership_verifier.sol";
import {LeanIMT, LeanIMTData} from "zk-kit.solidity/packages/lean-imt/contracts/LeanIMT.sol";
import {PoseidonT3} from "poseidon-solidity/PoseidonT3.sol";

contract Membership {
    using LeanIMT for LeanIMTData;

    IVerifier public immutable verifier;

    LeanIMTData public tree;

    constructor(IVerifier verifier_) {
        verifier = verifier_;
    }

    function getTree() public view returns (uint256 root, uint256 size, uint256 depth) {
        return (tree.root(), tree.size, tree.depth);
    }

    function addLeaf(uint256 leaf) public {
        tree.insert(leaf);
    }

    function verifyProof(bytes calldata proof) public returns (bool) {
        bytes32[] memory publicInputs = new bytes32[](1);
        publicInputs[0] = bytes32(tree.root());
        return verifier.verify(proof, publicInputs);
    }
}
