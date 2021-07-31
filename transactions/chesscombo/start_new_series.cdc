//start_new_series.cdc
import ChessCombo from "../../contracts/ChessCombo.cdc"

// This transaction is for an Admin to start a new Top Shot series

transaction {

    // Local variable for the topshot Admin object
    let adminRef: &ChessCombo.Admin

    prepare(acct: AuthAccount) {

        // borrow a reference to the Admin resource in storage
        self.adminRef = acct.borrow<&ChessCombo.Admin>(from: /storage/ChessComboAdmin)
            ?? panic("No admin resource in storage")
    }

    execute {
        
        // Increment the series number
        self.adminRef.startNewSeries()
    }
}