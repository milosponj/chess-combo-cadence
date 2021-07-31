import FungibleToken from "../../contracts/FungibleToken.cdc"
import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"
import ChessCombo from "../../contracts/ChessCombo.cdc"
import ChessComboMarket from "../../contracts/ChessComboMarket.cdc"
import Chessible from "../../contracts/Chessible.cdc"

transaction(saleItemID: UInt64, saleItemPrice: UFix64) {
    let chessibleVault: Capability<&Chessible.Vault{FungibleToken.Receiver}>
    let chessComboCollection: Capability<&ChessCombo.Collection{NonFungibleToken.Provider}>
    let marketCollection: &ChessComboMarket.Collection

    prepare(signer: AuthAccount) {
        // we need a provider capability, but one is not provided by default so we create one.
        let ChessComboCollectionProviderPrivatePath = /private/chessComboCollectionProvider
        self.chessibleVault = signer.getCapability<&Chessible.Vault{FungibleToken.Receiver}>(Chessible.ReceiverPublicPath)!
        assert(self.chessibleVault.borrow() != nil, message: "Missing or mis-typed Chessible receiver")

        if !signer.getCapability<&ChessCombo.Collection{NonFungibleToken.Provider}>(ChessComboCollectionProviderPrivatePath)!.check() {
            signer.link<&ChessCombo.Collection{NonFungibleToken.Provider}>(ChessComboCollectionProviderPrivatePath, target: ChessCombo.CollectionStoragePath)
        }

        self.chessComboCollection = signer.getCapability<&ChessCombo.Collection{NonFungibleToken.Provider}>(ChessComboCollectionProviderPrivatePath)!
        assert(self.chessComboCollection.borrow() != nil, message: "Missing or mis-typed ChessComboMarketCollection provider")

        self.marketCollection = signer.borrow<&ChessComboMarket.Collection>(from: ChessComboMarket.CollectionStoragePath)
            ?? panic("Missing or mis-typed ChessComboMarket Collection")
    }

    execute {
        let offer <- ChessComboMarket.createSaleOffer (
            sellerItemProvider: self.chessComboCollection,
            saleItemID: saleItemID,
            sellerPaymentReceiver: self.chessibleVault,
            salePrice: saleItemPrice
        )
        
        self.marketCollection.insert(offer: <-offer)
    }
}