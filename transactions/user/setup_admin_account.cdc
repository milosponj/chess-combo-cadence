import ChessCombo from "../../contracts/ChessCombo.cdc"

// this transaction adds an ChessCombo admin resource to a second provided account
transaction {
  prepare(acct: AuthAccount, acct2: AuthAccount) {
    let adminRef = acct.borrow<&ChessCombo.Admin>(from: ChessCombo.ChessComboAdminStoragePath)
            ?? panic("Could not borrow a reference to the Chess Combo Admin resource")
    acct2.save(<- adminRef.createNewAdmin(), to: ChessCombo.ChessComboAdminStoragePath)              
  }
}
