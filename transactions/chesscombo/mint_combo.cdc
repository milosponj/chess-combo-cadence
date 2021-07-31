import ChessCombo from "../../contracts/ChessCombo.cdc"

// This transaction is what an admin would use to mint a single new Combo
// and deposit it in a user's collection

// Parameters:
//
// compilationId: the Id of a compilation containing the targeted combination
// combinationId: the Id of a combination from which a new Combo is minted
// recipientAddr: the Flow address of the account receiving the newly minted Combo

transaction(compilationId: UInt32, combinationId: UInt32, recipientAddr: Address) {
    // local variable for the admin reference
    let adminRef: &ChessCombo.Admin

    prepare(acct: AuthAccount) {
        // borrow a reference to the Admin resource in storage
        self.adminRef = acct.borrow<&ChessCombo.Admin>(from: /storage/ChessComboAdmin)!
    }

    execute {
        // Borrow a reference to the specified set
        let setRef = self.adminRef.borrowCompilation(compilationId: compilationId)

        // Mint a new NFT
        let combo <- setRef.mintCombo(combinationId: combinationId)

        // get the public account object for the recipient
        let recipient = getAccount(recipientAddr)

        // get the Collection reference for the receiver
        let receiverRef = recipient.getCapability(ChessCombo.CollectionPublicPath).borrow<&{ChessCombo.ComboCollectionPublic}>()
            ?? panic("Cannot borrow a reference to the recipient's Combo collection")

        // deposit the NFT in the receivers collection
        receiverRef.deposit(token: <-combo)
    }
}