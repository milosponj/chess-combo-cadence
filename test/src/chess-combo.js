import { deployContractByName, executeScript, mintFlow, sendTransaction } from "flow-js-testing";
import { getChessComboAdminAddress } from "./common";

/*
 * Deploys NonFungibleToken and ChessCombo contracts to ChessComboAdmin.
 * @throws Will throw an error if transaction is reverted.
 * @returns {Promise<*>}
 * */
export const deployChessCombo = async () => {
	const ChessComboAdmin = await getChessComboAdminAddress();
	await mintFlow(ChessComboAdmin, "10.0");

	await deployContractByName({ to: ChessComboAdmin, name: "NonFungibleToken" });

	const addressMap = { NonFungibleToken: ChessComboAdmin };
	return deployContractByName({ to: ChessComboAdmin, name: "ChessCombo", addressMap });
};

/*
 * Setups ChessCombo collection on account and exposes public capability.
 * @param {string} account - account address
 * @throws Will throw an error if transaction is reverted.
 * @returns {Promise<*>}
 * */
export const setupChessComboOnAccount = async (account) => {
	const name = "chesscombo/setup_account";
	const signers = [account];

	return sendTransaction({ name, signers });
};

/*
 * Returns ChessCombo supply.
 * @throws Will throw an error if execution will be halted
 * @returns {UInt64} - number of NFT minted so far
 * */
export const getChessComboSupply = async () => {
	const name = "chesscombo/get_chess_combo_supply";

	return executeScript({ name });
};

export const getCurrentSeries = async () => {
	const name = "chesscombo/get_current_series";

	return executeScript({ name });
};

export const getNextCompilationId = async () => {
	const name = "chesscombo/get_next_compilation_id";

	return executeScript({ name });
};

export const getNextCombinationId = async () => {
	const name = "chesscombo/get_next_combination_id";

	return executeScript({ name });
};

export const getCombinationsInCompilation = async (compilationId) => {
	const name = "chesscombo/get_combinations_in_compilation";
	const args = [compilationId];

	return executeScript({ name, args });
};

export const createCompilation = async (compilationName) => {
	const ChessComboAdmin = await getChessComboAdminAddress();

	const name = "chesscombo/create_compilation";
	const args = [compilationName];
	const signers = [ChessComboAdmin];

	return sendTransaction({ name, args, signers });
};

export const createCombination = async (metadata) => {
	const ChessComboAdmin = await getChessComboAdminAddress();

	const args = [metadata];

	const name = "chesscombo/create_combination";
	const signers = [ChessComboAdmin];

	return sendTransaction({ name, args, signers });
};

export const addCombinationToCompilation = async (combinationId, compilationId) => {
	const ChessComboAdmin = await getChessComboAdminAddress();

	const name = "chesscombo/add_combination_to_compilation";
	const args = [combinationId, compilationId];
	const signers = [ChessComboAdmin];

	return sendTransaction({ name, args, signers });
};

export const startNewSeries = async () => {
	const ChessComboAdmin = await getChessComboAdminAddress();

	const name = "chesscombo/start_new_series";
	const args = [];
	const signers = [ChessComboAdmin];

	return sendTransaction({ name, args, signers });
};

/*
 * Mints ChessCombo and sends it to **recipient**.
 * @param {string} recipient - recipient account address
 * @throws Will throw an error if execution will be halted
 * @returns {Promise<*>}
 * */
export const mintCombo = async (compilationId, combinationId, recipient) => {
	const ChessComboAdmin = await getChessComboAdminAddress();

	const name = "chesscombo/mint_combo";
	const args = [compilationId, combinationId, recipient];
	const signers = [ChessComboAdmin];

	return sendTransaction({ name, args, signers });
};

/*
 * Transfers Combo NFT with id equal **itemId** from **sender** account to **recipient**.
 * @param {string} sender - sender address
 * @param {string} recipient - recipient address
 * @param {UInt64} itemId - id of the item to transfer
 * @throws Will throw an error if execution will be halted
 * @returns {Promise<*>}
 * */
export const transferCombo = async (sender, recipient, itemId) => {
	const name = "chesscombo/transfer_combo";
	const args = [recipient, itemId];
	const signers = [sender];

	return sendTransaction({ name, args, signers });
};

/*
 * Returns the length of account's ChessCombo collection.
 * @param {string} account - account address
 * @throws Will throw an error if execution will be halted
 * @returns {UInt64}
 * */
export const getCollectionLength = async (account) => {
	const name = "chesscombo/get_collection_length";
	const args = [account];

	return executeScript({ name, args });
};
