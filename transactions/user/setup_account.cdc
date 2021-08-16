import FungibleToken from "../../contracts/FungibleToken.cdc"
import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"
import FUSD from "../../contracts/FUSD.cdc"
import ChessCombo from "../../contracts/ChessCombo.cdc"
import NFTStorefront from "../../contracts/NFTStorefront.cdc"

  pub fun hasFUSD(_ address: Address): Bool {
    let receiver = getAccount(address)
      .getCapability<&FUSD.Vault{FungibleToken.Receiver}>(/public/fusdReceiver)
      .check()
    let balance = getAccount(address)
      .getCapability<&FUSD.Vault{FungibleToken.Balance}>(/public/fusdBalance)
      .check()
    return receiver && balance
  }
  pub fun hasItems(_ address: Address): Bool {
    return getAccount(address)
      .getCapability<&ChessCombo.Collection{NonFungibleToken.CollectionPublic, ChessCombo.ComboCollectionPublic}>(ChessCombo.CollectionPublicPath)
      .check()
  }
  pub fun hasStorefront(_ address: Address): Bool {
    return getAccount(address)
      .getCapability<&NFTStorefront.Storefront{NFTStorefront.StorefrontPublic}>(NFTStorefront.StorefrontPublicPath)
      .check()
  }
  transaction {
    prepare(acct: AuthAccount) {
      if !hasFUSD(acct.address) {
        if acct.borrow<&FUSD.Vault>(from: /storage/fusdVault) == nil {
          acct.save(<-FUSD.createEmptyVault(), to: /storage/fusdVault)
        }
        acct.unlink(/public/fusdReceiver)
        acct.unlink(/public/fusdBalance)
        acct.link<&FUSD.Vault{FungibleToken.Receiver}>(/public/fusdReceiver, target: /storage/fusdVault)
        acct.link<&FUSD.Vault{FungibleToken.Balance}>(/public/fusdBalance, target: /storage/fusdVault)
      }
      if !hasItems(acct.address) {
        if acct.borrow<&ChessCombo.Collection>(from: ChessCombo.CollectionStoragePath) == nil {
          acct.save(<-ChessCombo.createEmptyCollection(), to: ChessCombo.CollectionStoragePath)
        }
        acct.unlink(ChessCombo.CollectionPublicPath)
        acct.link<&ChessCombo.Collection{NonFungibleToken.CollectionPublic, ChessCombo.ComboCollectionPublic}>(ChessCombo.CollectionPublicPath, target: ChessCombo.CollectionStoragePath)
      }
      if !hasStorefront(acct.address) {
        if acct.borrow<&NFTStorefront.Storefront>(from: NFTStorefront.StorefrontStoragePath) == nil {
          acct.save(<-NFTStorefront.createStorefront(), to: NFTStorefront.StorefrontStoragePath)
        }
        acct.unlink(NFTStorefront.StorefrontPublicPath)
        acct.link<&NFTStorefront.Storefront{NFTStorefront.StorefrontPublic}>(NFTStorefront.StorefrontPublicPath, target: NFTStorefront.StorefrontStoragePath)
      }
    }
  }