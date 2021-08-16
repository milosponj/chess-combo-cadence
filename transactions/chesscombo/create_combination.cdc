import ChessCombo from "../../contracts/ChessCombo.cdc"
// This transaction creates a new combination struct 
// and stores it in the ChessCombo smart contract

// Parameters:
//
// metadata: A dictionary of all the combo metadata associated

transaction(metadata: {String: String}) {

    // Local variable for the ChessCombo Admin object
    let adminRef: &ChessCombo.Admin

    prepare(acct: AuthAccount) {

        // borrow a reference to the admin resource
        self.adminRef = acct.borrow<&ChessCombo.Admin>(from: /storage/ChessComboAdmin)
            ?? panic("No admin resource in storage")
    }

    execute {

        // Create a play with the specified metadata
        self.adminRef.createCombination(metadata: metadata)
    }
}