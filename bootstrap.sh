#!/bin/bash
# 1. Prompt the user for input
read -p "Choose a plugin name: " plugin_name
## lowercase the plugin name
plugin_name=$(echo "$plugin_name" | tr '[:upper:]' '[:lower:]')


# 2. Create a test app to install the plugin inside

## Clean up the test-app directory if it exists
rm -rf test-app

## Download plugin dependencies
npm install

## Dowload and install the template into a subdirectory
npx degit evidence-dev/template test-app
cd test-app
npm install

## Add the plugin to the test-app
npm install ..

## Add the connector to the evidence.plugins.yaml file
echo "  \"evidence-connector-$plugin_name\": {}" >> evidence.plugins.yaml

## Create a source in the test app
rm -rf sources/test_source
mkdir sources/test_$plugin_name
echo """name: test_$plugin_name
type: $plugin_name
""" >> sources/test_$plugin_name/connection.yaml
echo "select 1" >> sources/test_$plugin_name/test_query.sql

## Edit the index.md file to show the test_query in a table
cd pages
echo """## $plugin_name plugin is working!
\`\`\`sql test_plugin
select * from test_$plugin_name.test_query
\`\`\`
<DataTable data={test_plugin} />
""" > index.md

cd ../../

# 3. Update the plugin files

## Read the existing package.json into a variable
package_json=$(<package.json)

## Update the package name
package_json=$(echo "$package_json" | sed "s/\"name\": \".*\"/\"name\": \"evidence-connector-$plugin_name\"/")


## Prepare the datasources array
datasources_array="[ \"$plugin_name\" ]"
package_json=$(echo "$package_json" | sed "s/\"datasources\": \[[^]]*\]/\"datasources\": $datasources_array/")

## Write the updated package.json back to the file
echo "$package_json" > package.json
echo "package.json has been updated."

## Move the README.md into a gitignored file /plugin-template/README.md
## Create a new README.md with the title Evidence [plugin_name] Source Plugin
mkdir -p plugin-template
mv README.md plugin-template/README.md
echo "# Evidence $plugin_name Source Plugin

Install this plugin in an Evidence app with
\`\`\`bash
npm install evidence-connector-$plugin_name
\`\`\`

Register the plugin in your project in your evidence.plugins.yaml file with
\`\`\`bash
datasources:
  evidence-connector-$plugin_name: {}
\`\`\`

Launch the development server with \`npm run dev\` and navigate to the settings menu (localhost:3000/settings) to add a data source using this plugin.
" > README.md

## Move the scaffold.sh and bootstrap.sh to the plugin-template folder
mv bootstrap.sh plugin-template/bootstrap.sh

echo "README.md, scaffold.sh and bootstrap.sh have been moved to plugin-template"

