import Chessible from "../../contracts/Chessible.cdc"

// This script returns the total amount of Chessible currently in existence.

pub fun main(): UFix64 {

    let supply = Chessible.totalSupply

    log(supply)

    return supply
}
