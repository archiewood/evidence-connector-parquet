# Evidence Parquet Source Plugin

## Installation

Install this plugin in an Evidence app with
```bash
npm install evidence-connector-parquet
```

Register the plugin in your project in your evidence.plugins.yaml file with
```bash
datasources:
  evidence-connector-parquet: {}
```

## Usage

1. Launch the development server with `npm run dev` and navigate to the settings menu (localhost:3000/settings) to add a data source using this plugin.
2. (Optional) Specify [options for the Parquet reader](https://duckdb.org/docs/data/parquet/overview.html#parameters) in the data source settings.
3. Save the data source
4. Add your parquet files to `/sources/your-source-name/`.
5. Run `npm run sources` to load the data into Evidence.
6. Each parquet file will be accessible as a table:
   - `hello.parquet` -> `select * from hello`
   - `My Parquet File.parquet` -> `select * from "My Parquet File"`

> **Note:** If you use spaces, hyphens or special characters in the file name, you must use the double quotes in the table name.
