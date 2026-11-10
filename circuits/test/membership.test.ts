// @ts-ignore - bun:test resolves at runtime under bun; TS server can't see bun-types from circuits/
import { describe, expect, test } from "bun:test"
import { LeanIMT } from "@zk-kit/lean-imt"
import { poseidon2Hash } from "@zkpassport/poseidon2"
import { Prover } from "../src/prover"

// The membership circuit fixes the merkle_path length to 32 and skips zero
// entries, so a LeanIMT proof (dynamic depth) pads to this length.
const MERKLE_PATH_LENGTH = 32

const hashNode = (left: bigint, right: bigint): bigint => poseidon2Hash([left, right])

function buildTree(leaves: bigint[]): LeanIMT<bigint> {
  const tree = new LeanIMT<bigint>(hashNode)
  tree.insertMany(leaves)
  return tree
}

function getCircuitInputs(tree: LeanIMT<bigint>, leafIndex: number) {
  const proof = tree.generateProof(leafIndex)
  return {
    merkle_root: tree.root.toString(),
    merkle_path: [...proof.siblings, ...Array(MERKLE_PATH_LENGTH - proof.siblings.length).fill(0n)].map(String),
    merkle_index: proof.index.toString(),
    merkle_leaf: proof.leaf.toString(),
  }
}

describe("membership proof", () => {
  const prover = new Prover("membership")

  const leaf = 42n
  const tree = buildTree([leaf, 100n, 200n, 300n])

  test("generates and verifies a proof of membership for a leaf", async () => {
    const inputs = getCircuitInputs(tree, 0)
    expect(inputs.merkle_leaf).toBe(leaf.toString())

    const proof = await prover.prove(inputs)
    expect(proof).toBeDefined()
    expect(proof.proof.length).toBeGreaterThan(0)

    const verified = await prover.verify(proof)
    expect(verified).toBeTrue()
  }, 300_000)

  test("rejects a proof for a leaf not in the tree", async () => {
    const inputs = getCircuitInputs(tree, 1)
    inputs.merkle_leaf = "999"

    expect(prover.prove(inputs)).rejects.toThrow()
  }, 300_000)
})
