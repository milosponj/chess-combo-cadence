import ChessCombo from "../../contracts/ChessCombo.cdc"

pub fun main(compilationId: UInt32): [UInt32]? {    
    return ChessCombo.getCombinationsInCompilation(compilationId: compilationId)
}