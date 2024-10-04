# Evidence Source Plugin Template

Use this template to create a new Evidence source plugin. The template includes a simple example plugin, which you can use to get started.


## Install and run the sample plugin

Click the "Use this template" button above to create a new repository from this template. The convention for the repo name is `evidence-connector-[sourcename]`.

Open your repository and run the following (you may need to run `chmod +x bootstrap.sh` to make the scripts executable)

```bash
./bootstrap.sh
./run-plugin.sh
```

These commands:
- Installs a sample plugin
- Create a test Evidence app in `test-app`
- Install the sample plugin in the test app
- Add a source to the test app
- Run the test app

To verify the plugin works, scroll to the bottom of the app homepage and you should see "Test Plugin is working" with some sample data in a table.

## Make the plugin your own

### Modify the plugin code

The plugin code is in [`src/index.js`](./src/index.js).

Evidence accepts 2 different interfaces when using datasources:
1. File-based Interface: Each file in the user's source directory is processed by `getRunner`
2. Advanced Interface: Files are not explcitly processed by `getRunner`, and instead the `processSource` function is implemented.

> Note that [`lib.js`](./src/lib.js) has a stubbed `databaseTypeToEvidenceType`, which is helpful for building `ColumnTypes` more easily.

#### File-based Interface

For the file-based interface, modify the `getRunner` function; which is a factory pattern for building a configured QueryRunner.

The sample plugin uses the file-based interface.

Each query can either return an array of results, or an [async generator function](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/async_function*) if implementing cursor logic (this enables much larger datasets)

#### Advanced Interface (File-independent)

For the advanced interface, implement the `processSource` function; which is an [async generator function](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/async_function*) returning tables directly.

`processSource` receives a proxy of the source's filetree, so it must look for files itself, but returns results in the same available formats as `getRunner`. `processSource` should be used in instances where ***output tables do not map one to one with input files*** (e.g. if a list of tables is provided in `connection.yaml` that should all be `SELECT *`'d)

### Specify any plugin options

[`index.js`](./src/index.js) defines the type `ConnectorOptions`, and exports an `options` constant.  

`ConnectorOptions` should be typed to the expected configuration for your datasource (e.g. hostname, port, etc)  

`options` defines how your connector will be configured in the UI, see the [docs](https://docs.evidence.dev/plugins/create-source-plugin/), and/or taking a look at the [Evidence Postgres Connector](https://github.com/evidence-dev/evidence/blob/main/packages/datasources/postgres/index.cjs#L242).

### [Optional] Add aliases and icons to package.json

1. If your connector supports multiple sources, or you have several aliases (e.g. psql, postgres, postgresql), you can provide a nested array, this will show only the first item in the UI
    - In this example, `postgres`, `psql`, `postgresql`, `redshift`, and `timescaledb` will all select this connector  
    However, only `postgres`, `redshift`, and `timescaledb` will be presented as options in the UI.
```json
{
    "evidence": {
        "datasources": [
            [ "postgres", "psql", "postgresql" ],  // Shows only `postgres` in the UI
            "redshift",
            "timescaledb"
        ]
    }
}
```
2. Specify an icon for your datasource.
    1. Icons can come from [Simple Icons](https://simpleicons.org/), or [Tabler Icons](https://tabler-icons.io/).
    2. Evidence uses [Steeze UI](https://github.com/steeze-ui/icons#icon-packs) for our icons, so the casing must match  
        the Steeze UI export
   ```json
   {
       "evidence": {
           "icon": "YourIconName"
       }
   }
   ```

### [Recommended] Write Unit Tests

This template comes with [`vitest`](https://vitest.dev/) pre-installed. If you've used [jest](https://jestjs.io/), vitest implements a very similar API.

Tests have been stubbed in [`index.spec.js`](./src/index.spec.js), and can be run with `npm run test`

### Publishing to npm

You need an npm account to publish your plugin. 
If you don't have one, you can [sign up](https://www.npmjs.com/signup) for free.

To publish your connector to npm, follow these steps:

1. **Login to npm**: If you haven't already, you need to login to your npm account. You can do this by running:

```bash
npm login
```

2. **Publish the package**: Once you are logged in and the version is updated in package.json, you can publish your package by running:

```bash
npm publish
```