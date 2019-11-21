# Abort if the current folder is not empty
if [ "$(ls -A ./)" ]; then
  echo "The current directory is not empty. Aborting."
  exit 1;
fi

# Create git repo
git init

# Create .gitignore
echo 'node_modules/
dist/
.cache/' > .gitignore

# Get Node and NPM versions (cut the 'v' off the Node version)
node_version=$(node -v | sed -e 's/^v//')
npm_version=$(npm -v)

# Create package.json
echo '{
  "name": "'$1'",
  "version": "0.0.0",
  "scripts": {
    "start": "parcel src/index.html",
    "build": "parcel build src/index.html"
  },
  "private": true,
  "license": "UNLICENSED",
  "engines": {
    "node": "'^$node_version'",
    "npm": "'^$npm_version'"
  }
}' > package.json

# Install dependencies
npm i -D babel-core babel-preset-env classnames @types/classnames parcel parcel-plugin-clean-dist postcss postcss-modules preact redux-zero sass typescript

# Add directories
mkdir -p src/components/App
mkdir -p src/@types/scss
mkdir -p src/store/actions

# Static files
# ============
# .babelrc
echo '{
  "presets": [
    ["env", {
      "targets": {
        "browsers": ["last 2 Chrome versions"]
      }
    }]
  ]
}' > .babelrc

# .postcssrc
echo '{
  "modules": true
}' > .postcssrc

# tsconfig.json
echo '{
  "compilerOptions": {
    "module": "commonjs",
    "moduleResolution": "node",
    "target": "es2018",
    "lib": [
      "es2018",
      "esnext.array",
      "scripthost",
      "dom"
    ],
    "strict": true,
    "baseUrl": "./",
    "paths": {
      "*": ["src/@types/*"]
    },
    "jsx": "react",
    "jsxFactory": "h",
    "esModuleInterop": true
  }
}' > tsconfig.json

# src/index.html
echo '<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Document</title>
  </head>
  <body>
    <div id="app"></div>
    <script src="./index.tsx"></script>
  </body>
</html>' > src/index.html

# src/index.tsx
echo "import {h, render} from 'preact';
import App from './components/App';

render(<App/>, document.getElementById('app')!);" > src/index.tsx

# src/types.d.ts
echo "export interface State {
  greeting: string;
}" > src/types.d.ts

# src/@types/scss/index.d.ts
echo "declare module '*.scss';" > src/@types/scss/index.d.ts

# src/store/index.ts
echo "import createStore from 'redux-zero';
import getInitialState from './getInitialState';

const store = createStore(getInitialState());

export default store;" > src/store/index.ts

# src/store/getInitialState.ts
echo "import {State} from '../types';

const getInitialState = (): State => ({
  greeting: 'Hello, world!',
});

export default getInitialState;" > src/store/getInitialState.ts

# src/store/actions/state.ts
echo "import store from '../';
import {State} from '../../types';

export const getState = () => store.getState();
export const setState = (newState: Partial<State>) => store.setState(newState);" > src/store/actions/state.ts

# src/components/App/index.tsx
echo "import {h} from 'preact';
import {Connect, Provider} from 'redux-zero/preact';
import store from '../../store';
import {setState} from '../../store/actions/state';
import {State} from '../../types';
import styles from './styles.scss';

type StateProps = Pick<State, 'greeting'>;
const mapToProps = ({greeting}: State): StateProps => ({greeting});

const leave = () => setState({greeting: 'Goodbye, cruel world!'});

const App = () => (
  <Provider store={store}>
    <Connect mapToProps={mapToProps}>
      {({greeting}: StateProps) => (
        <div class={styles.app}>
          {greeting}<br/>
          <button class={styles.button} onClick={leave}>Goodbye</button>
        </div>
      )}
    </Connect>
  </Provider>
);

export default App;" > src/components/App/index.tsx

# src/components/App/styles.scss
echo ':global {
  html, body {
    margin: 0;
    padding: 0;
  }
  * {
    box-sizing: inherit;
    cursor: inherit;
    user-select: inherit;
  }
}

.app {
  font-family: "Trebuchet MS", sans-serif;
  cursor: default;
  user-select: none;
  box-sizing: border-box;
  padding: 12px;
}

.button {
  margin-top: 8px;
}' > src/components/App/styles.scss

# Start dev mode
# ==============
if [ -x "$(command -v xdg-open)" ]; then
  npm start & xdg-open http://localhost:1234
elif [ -x "$(command -v open)" ]; then
  npm start & open http://localhost:1234
elif [ -x "$(command -v start)" ]; then
  npm start & start http://localhost:1234
fi
