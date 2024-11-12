-include .env

# build: 
#     forge build

# test: 
#     forge test

deploy:
    forge script script/fundMeScript.s.sol:fundMeScript --rpc-url $(SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY)
