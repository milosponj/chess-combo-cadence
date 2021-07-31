import FungibleToken from "../../contracts/FungibleToken.cdc"
import Chessible from "../../contracts/Chessible.cdc"
import ChessComboMarket from "../../contracts/ChessComboMarket.cdc"
import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"
import ChessCombo from "../../contracts/ChessCombo.cdc"

// This transaction configures an account to hold Combos.


  pub fun hasChessible(_ address: Address): Bool {
    let receiver = getAccount(address)
      .getCapability<&Chessible.Vault{FungibleToken.Receiver}>(Chessible.ReceiverPublicPath)
      .check()

    let balance = getAccount(address)
      .getCapability<&Chessible.Vault{FungibleToken.Balance}>(Chessible.BalancePublicPath)
      .check()

    return receiver && balance
  }

  pub fun hasItems(_ address: Address): Bool {
    return getAccount(address)
      .getCapability<&ChessCombo.Collection{NonFungibleToken.CollectionPublic, ChessCombo.ComboCollectionPublic}>(ChessCombo.CollectionPublicPath)
      .check()
  }

  pub fun hasMarket(_ address: Address): Bool {
    return getAccount(address)
      .getCapability<&ChessComboMarket.Collection{ChessComboMarket.CollectionPublic}>(ChessComboMarket.CollectionPublicPath)
      .check()
  }

  transaction {
    prepare(acct: AuthAccount) {
      if !hasChessible(acct.address) {
        if acct.borrow<&Chessible.Vault>(from: Chessible.VaultStoragePath) == nil {
          acct.save(<-Chessible.createEmptyVault(), to: Chessible.VaultStoragePath)
        }
        acct.unlink(Chessible.ReceiverPublicPath)
        acct.unlink(Chessible.BalancePublicPath)
        acct.link<&Chessible.Vault{FungibleToken.Receiver}>(Chessible.ReceiverPublicPath, target: Chessible.VaultStoragePath)
        acct.link<&Chessible.Vault{FungibleToken.Balance}>(Chessible.BalancePublicPath, target: Chessible.VaultStoragePath)
      }

      if !hasItems(acct.address) {
        if acct.borrow<&ChessCombo.Collection>(from: ChessCombo.CollectionStoragePath) == nil {
          acct.save(<-ChessCombo.createEmptyCollection(), to: ChessCombo.CollectionStoragePath)
        }
        acct.unlink(ChessCombo.CollectionPublicPath)
        acct.link<&ChessCombo.Collection{NonFungibleToken.CollectionPublic, ChessCombo.ComboCollectionPublic}>(ChessCombo.CollectionPublicPath, target: ChessCombo.CollectionStoragePath)
      }

      if !hasMarket(acct.address) {
        if acct.borrow<&ChessComboMarket.Collection>(from: ChessComboMarket.CollectionStoragePath) == nil {
          acct.save(<-ChessComboMarket.createEmptyCollection(), to: ChessComboMarket.CollectionStoragePath)
        }
        acct.unlink(ChessComboMarket.CollectionPublicPath)
        acct.link<&ChessComboMarket.Collection{ChessComboMarket.CollectionPublic}>(ChessComboMarket.CollectionPublicPath, target:ChessComboMarket.CollectionStoragePath)
      }
    }
  }
