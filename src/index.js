import { exhaustStream } from '@evidence-dev/db-commons';
import runQuery from '@evidence-dev/duckdb';

/**
 * @typedef {Object} DuckDBOptions
 * @property {string} options
 */

/** @type {import("@evidence-dev/db-commons").RunQuery<DuckDBOptions>} */
export default async (queryString, _, batchSize = 100000) => {
	return runQuery(queryString, { filename: ':memory:' }, batchSize);
};

/** @type {import("@evidence-dev/db-commons").GetRunner<DuckDBOptions>} */
export const getRunner = ({ options }) => {
	return async (queryContent, queryPath, batchSize) => {
		// Filter out non-csv files
		if (!queryPath.endsWith('.csv')) return null;
		// Use DuckDBs auto CSV loading
		// https://duckdb.org/docs/data/csv/overview.html
		const quotedQueryPath = `'${queryPath}'`;
		const optionsArray = options?.split(',') ?? [];
		if (!options?.toLowerCase().includes('auto_detect')) {
			optionsArray.push('auto_detect = true');
		}

		return runQuery(
			`SELECT * FROM read_csv(${[quotedQueryPath, ...optionsArray].join(', ')})`,
			{ filename: ':memory:' },
			batchSize
		);
	};
};

/** @type {import("@evidence-dev/db-commons").ConnectionTester<DuckDBOptions>} */
export const testConnection = async (opts) => {
	const r = await runQuery('SELECT 1;', { ...opts, filename: ':memory:' })
		.then(exhaustStream)
			.then(() => true)
			.catch((e) => ({ reason: e.message ?? 'File not found' }));
	return r;
};

export const options = {
	options: {
		title: 'Options',
		description:
			"String passed directly to duckdb's CSV import. See https://duckdb.org/docs/data/csv/overview.html for available configuration",
		type: 'string',
		secret: false,
		shown: true,
		virtual: false,
		nest: false,
		default: ''
	}
};