import FungibleToken from "../../contracts/FungibleToken.cdc"
import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"
import FUSD from "../../contracts/FUSD.cdc"
import ChessCombo from "../../contracts/ChessCombo.cdc"
import NFTStorefront from "../../contracts/NFTStorefront.cdc"

transaction(saleOfferResourceID: UInt64, storefrontAddress: Address) {

    let paymentVault: @FungibleToken.Vault
    let chessComboCollection: &ChessCombo.Collection{NonFungibleToken.Receiver}
    let storefront: &NFTStorefront.Storefront{NFTStorefront.StorefrontPublic}
    let saleOffer: &NFTStorefront.SaleOffer{NFTStorefront.SaleOfferPublic}

    prepare(account: AuthAccount) {
        self.storefront = getAccount(storefrontAddress)
            .getCapability<&NFTStorefront.Storefront{NFTStorefront.StorefrontPublic}>(
                NFTStorefront.StorefrontPublicPath
            )!
            .borrow()
            ?? panic("Could not borrow Storefront from provided address")

        self.saleOffer = self.storefront.borrowSaleOffer(saleOfferResourceID: saleOfferResourceID)
            ?? panic("No Offer with that ID in Storefront")
        
        let price = self.saleOffer.getDetails().salePrice

        let mainFUSDVault = account.borrow<&FUSD.Vault>(from: /storage/fusdVault)
            ?? panic("Cannot borrow FUSD vault from account storage")
        
        self.paymentVault <- mainFUSDVault.withdraw(amount: price)

        self.chessComboCollection = account.borrow<&ChessCombo.Collection{NonFungibleToken.Receiver}>(
            from: ChessCombo.CollectionStoragePath
        ) ?? panic("Cannot borrow ChessCombo collection receiver from account")
    }

    execute {
        let item <- self.saleOffer.accept(
            payment: <-self.paymentVault
        )

        self.chessComboCollection.deposit(token: <-item)

        self.storefront.cleanup(saleOfferResourceID: saleOfferResourceID)
    }
}