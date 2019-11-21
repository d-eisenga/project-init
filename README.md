# Project initializer

A script to quickly initialize a web frontend project using [TypeScript], [Preact], and [Redux Zero].

## Usage
Open a terminal and navigate to the folder inside which you want to create your project folder.

Run the following code, with `<project-name>` replaced with a [valid package.json name][pkg-name]:

```sh
curl https://raw.githubusercontent.com/d-eisenga/project-init/master/init.sh | bash -s <project-name>
```

The script will create a new directory, create all relevant files, and install the latest versions
of all dependencies.

[TypeScript]: https://www.typescriptlang.org/
[Preact]: https://preactjs.com/
[Redux Zero]: https://matheusml1.gitbooks.io/redux-zero-docs/content/
[pkg-name]: https://docs.npmjs.com/files/package.json#name
