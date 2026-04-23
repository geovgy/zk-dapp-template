# zk-dapp-template

A starter template for building zero-knowledge dApps with Noir circuits, Solidity smart contracts, and a React frontend.

## Prerequisites

- [Bun](https://bun.com)
- [Foundry](https://book.getfoundry.sh/getting-started/installation)
- [Nargo](https://noir-lang.org/docs/getting_started/quick_start) (v1.0.0-beta.18)

## 1. Build Circuits

```bash
cd circuits
bun run build
```

This compiles the Noir circuits. Then export the Solidity verifier and compiled circuit artifacts:

```bash
bun export-contracts
bun export-app
```

- `export-contracts` generates the Solidity verifier contract into `contracts/`
- `export-app` adds the compiled circuit artifacts to `app/`

## 2. Build Contracts

```bash
cd contracts
forge install
forge build
```

## 3. Deploy Contracts

```bash
forge script script/YourContract.s.sol
```

## 4. Run the App

```bash
cd app
```

Set the deployed contract address in the app configuration, then start the dev server:

```bash
bun run dev
```

### Generating Proofs in the Browser

The template includes a `Prover` helper at `app/src/lib/prover.ts` that handles initializing the WASM modules, loading compiled circuits, and generating/verifying proofs. Usage:

```typescript
import { Prover } from "./lib/prover";

const prover = new Prover("your_circuit");
await prover.init();

// Generate a proof
const proof = await prover.prove({ input1: "value1", input2: "value2" });

// Verify a proof
const isValid = await prover.verify(proof);
```

Update the `CircuitType` type and `getCircuitPath` in `prover.ts` to match your circuit names. The compiled circuit JSON files are loaded from `app/artifacts/circuits/` (populated by `bun export-app` in step 1).
