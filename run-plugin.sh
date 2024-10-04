#!/bin/bash
# Update the plugin dependencies
npm install

# Install the plugin into the test app
cd test-app
npm install ..

# Run the test app
npm run sources
npm run dev