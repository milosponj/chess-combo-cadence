import { deployContractByName, executeScript, mintFlow, sendTransaction } from "flow-js-testing";
import { getChessComboAdminAddress } from "./common";

export const deployPackDropper = async () => {
	const ChessComboAdmin = await getChessComboAdminAddress();
	await mintFlow(ChessComboAdmin, "10.0");

	await deployContractByName({ to: ChessComboAdmin, name: "FungibleToken" });
	await deployContractByName({ to: ChessComboAdmin, name: "FUSD" });

	const addressMap = { NonFungibleToken: ChessComboAdmin, FUSD: ChessComboAdmin };
	return deployContractByName({ to: ChessComboAdmin, name: "PackDropper", addressMap });
};

export const getPackIds = async () => {
	const ChessComboAdmin = await getChessComboAdminAddress();

	const name = "packdropper/get_pack_ids";
	const args = [ChessComboAdmin];

	return executeScript({ name, args });
};

export const getPackBuyers = async (packId) => {
	const ChessComboAdmin = await getChessComboAdminAddress();

	const name = "packdropper/get_pack_buyers";
	const args = [packId, ChessComboAdmin];

	return executeScript({ name, args });
};

export const getPackPrice = async (packId) => {
	const ChessComboAdmin = await getChessComboAdminAddress();

	const name = "packdropper/get_pack_price";
	const args = [packId, ChessComboAdmin];

	return executeScript({ name, args });
};

export const addPack = async (packName, size, price, availableFrom) => {
	const ChessComboAdmin = await getChessComboAdminAddress();

	const name = "packdropper/add_pack";
	const args = [packName, size, price, availableFrom];
	const signers = [ChessComboAdmin];

	return sendTransaction({ name, args, signers });
};

export const buyPack = async (packId, buyer) => {
	const ChessComboAdmin = await getChessComboAdminAddress();

	const name = "packdropper/buy_pack";
	const args = [packId, ChessComboAdmin];
	const signers = [buyer];

	return sendTransaction({ name, args, signers });
};
