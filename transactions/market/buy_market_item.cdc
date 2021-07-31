import FungibleToken from 0x03
import NonFungibleToken from 0x02
import ChessCombo from 0x01
import ChessComboMarket from 0x04


transaction(saleItemID: UInt64, marketCollectionAddress: Address) {
    let paymentVault: @FungibleToken.Vault
    let chessComboCollection: &ChessCombo.Collection{NonFungibleToken.Receiver}
    let marketCollection: &ChessComboMarket.Collection{ChessComboMarket.CollectionPublic}

    prepare(signer: AuthAccount) {
        self.marketCollection = getAccount(marketCollectionAddress)
            .getCapability<&ChessComboMarket.Collection{ChessComboMarket.CollectionPublic}>(
                ChessComboMarket.CollectionPublicPath
            )!
            .borrow()
            ?? panic("Could not borrow market collection from market address")

        let saleItem = self.marketCollection.borrowSaleItem(saleItemID: saleItemID)
                    ?? panic("No item with that ID")
        let price = saleItem.salePrice

        let mainVault = signer.borrow<&FungibleToken.Vault>(from: /storage/VaultStoragePath_TODO_REPLACE_WITH_VARIABLE)
            ?? panic("Cannot borrow vault from acct storage")
        self.paymentVault <- mainVault.withdraw(amount: price)

        self.chessComboCollection = signer.borrow<&ChessCombo.Collection{NonFungibleToken.Receiver}>(
            from: ChessCombo.CollectionStoragePath
        ) ?? panic("Cannot borrow ChessCombo collection receiver from acct")
    }

    execute {
        self.marketCollection.purchase(
            saleItemID: saleItemID,
            buyerCollection: self.chessComboCollection,
            buyerPayment: <- self.paymentVault
        )
    }
}