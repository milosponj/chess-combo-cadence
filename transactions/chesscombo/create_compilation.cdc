import ChessCombo from "../../contracts/ChessCombo.cdc"

// This transaction is for the admin to create a new set resource
// and store it in the ChessCombo smart contract

// Parameters:
//
// compilationName: the name of a new Compilation to be created

transaction(compilationName: String) {
    
    // Local variable for the ChessCombo Admin object
    let adminRef: &ChessCombo.Admin

    prepare(acct: AuthAccount) {

        // borrow a reference to the Admin resource in storage
        self.adminRef = acct.borrow<&ChessCombo.Admin>(from: /storage/ChessComboAdmin)
            ?? panic("Could not borrow a reference to the Admin resource")
    }

    execute {
        
        // Create a set with the specified name
        self.adminRef.createCompilation(name: compilationName)
    }
}