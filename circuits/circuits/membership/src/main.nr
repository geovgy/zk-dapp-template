mod merkle;

use merkle::calculate_root;
use poseidon::poseidon2::Poseidon2::hash;

fn hasher(inputs: [Field; 2]) -> Field {
    hash(inputs, 2)
}

fn main(
    merkle_root: pub Field,
    merkle_path: [Field; 32],
    merkle_index: Field,
    merkle_leaf: Field,
) {
    let root = calculate_root(hasher, merkle_leaf, merkle_index, merkle_path);
    assert(root == merkle_root);
}
