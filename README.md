# Chess-combo-cadence

Repo that contains flow contracts for chess combo

# Process for creating a new test account

1. First generate new keys

```sh
flow keys generate
```

2. Go to https://testnet-faucet-v2.onflow.org/?
3. Paste in the public key
4. Copy over the address generated on the web page to the flow.json

# Deploying to newly created account

Run this command:

```sh
flow project deploy --network=testnet
```