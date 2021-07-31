import FungibleToken from "../../contracts/FungibleToken.cdc"
import Chessible from "../../contracts/Chessible.cdc"

// This transaction is a template for a transaction
// to add a Vault resource to their account
// so that they can use the Chessible

transaction {

    prepare(signer: AuthAccount) {

        if signer.borrow<&Chessible.Vault>(from: Chessible.VaultStoragePath) == nil {
            // Create a new Chessible Vault and put it in storage
            signer.save(<-Chessible.createEmptyVault(), to: Chessible.VaultStoragePath)

            // Create a public capability to the Vault that only exposes
            // the deposit function through the Receiver interface
            signer.link<&Chessible.Vault{FungibleToken.Receiver}>(
                Chessible.ReceiverPublicPath,
                target: Chessible.VaultStoragePath
            )

            // Create a public capability to the Vault that only exposes
            // the balance field through the Balance interface
            signer.link<&Chessible.Vault{FungibleToken.Balance}>(
                Chessible.BalancePublicPath,
                target: Chessible.VaultStoragePath
            )
        }
    }
}
