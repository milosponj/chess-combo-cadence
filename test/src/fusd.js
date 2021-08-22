import { deployContractByName, executeScript, mintFlow, sendTransaction } from "flow-js-testing";
import { getChessComboAdminAddress } from "./common";

export const deployFusd = async () => {
	const ChessComboAdmin = await getChessComboAdminAddress();
	await mintFlow(ChessComboAdmin, "10.0");

	return deployContractByName({ to: ChessComboAdmin, name: "FUSD" });
};

export const setupFUSDOnAccount = async (account) => {
	const name = "fusd/setup_account";
	const signers = [account];

	return sendTransaction({ name, signers });
};

export const mintFUSD = async (recipient, amount) => {
	const ChessComboAdmin = await getChessComboAdminAddress();

	const name = "fusd/mint_tokens";
	const args = [recipient, amount];
	const signers = [ChessComboAdmin];

	return sendTransaction({ name, args, signers });
};
