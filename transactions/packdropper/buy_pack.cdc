import PackDropper from "../../contracts/PackDropper.cdc"
import FungibleToken from "../../contracts/FungibleToken.cdc"
import Chessible from "../../contracts/Chessible.cdc"

transaction(itemID: UInt32, packsHandlerAddress: Address) {
    let packsHandler: &PackDropper.PacksHandler{PackDropper.PackPurchaser}

    prepare(signer: AuthAccount) {
        self.packsHandler = getAccount(packsHandlerAddress)
            .getCapability<&PackDropper.PacksHandler{PackDropper.PackPurchaser}>(
                PackDropper.PacksHandlerPublicPath
            )
            .borrow()
            ?? panic("Could not borrow PacksHandler from PacksHandler address")   

        let packPrice = self.packsHandler.getPackPrice(packId: itemID)

        let mainChessibbleVault = signer.borrow<&Chessible.Vault>(from: Chessible.VaultStoragePath)
            ?? panic("Cannot borrow Chessible vault from acct storage")
        let paymentVault <- mainChessibbleVault.withdraw(amount: packPrice)

        self.packsHandler.buyPack(packId: itemID, buyerPayment: <-paymentVault, buyerAddress: signer.address)
    }

    execute {
    }
}