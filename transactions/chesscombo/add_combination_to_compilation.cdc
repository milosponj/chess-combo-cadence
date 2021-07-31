import ChessCombo from "../../contracts/ChessCombo.cdc"

// This transaction is how a ChessCombo admin adds a created Combination to a Compilation

// Parameters:
//
// compilationId: the ID of the Compilation to which a created Combination is added
// combinationId: the ID of the Combination being added

transaction(combinationId: UInt32, compilationId: UInt32) {

    let adminRef: &ChessCombo.Admin

    prepare(acct: AuthAccount) {
        self.adminRef = acct.borrow<&ChessCombo.Admin>(from: /storage/ChessComboAdmin)
            ?? panic("Could not borrow a reference to the Admin resource")
    }

    execute {
        let compilationRef = self.adminRef.borrowCompilation(compilationId: compilationId)
        compilationRef.addCombination(combinationId: combinationId)
    }
}