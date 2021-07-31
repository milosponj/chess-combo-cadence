import Chessible from "../../contracts/Chessible.cdc"
import FungibleToken from "../../contracts/FungibleToken.cdc"

// This script returns an account's Chessible balance.

pub fun main(address: Address): UFix64 {
    let account = getAccount(address)
    
    let vaultRef = account.getCapability(Chessible.BalancePublicPath)!.borrow<&Chessible.Vault{FungibleToken.Balance}>()
        ?? panic("Could not borrow Balance reference to the Vault")

    return vaultRef.balance
}
