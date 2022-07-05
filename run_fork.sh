export $(cat .env)

forge test --fork-url $FORK_RPC_URL --etherscan-api-key $ETHERSCAN_API_KEY