import { deployContractByName, executeScript, mintFlow, sendTransaction } from "flow-js-testing";
import { getChessComboAdminAddress } from "./common";

export const deployPackHandler = async () => {
	const ChessComboAdmin = await getChessComboAdminAddress();
	await mintFlow(ChessComboAdmin, "10.0");

	await deployContractByName({ to: ChessComboAdmin, name: "NonFungibleToken" });

	const addressMap = { NonFungibleToken: ChessComboAdmin };
	return deployContractByName({ to: ChessComboAdmin, name: "ChessCombo", addressMap });
};
