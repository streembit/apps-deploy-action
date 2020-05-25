# apps-deploy-action
CI/CD workflow

# Credits
Based on https://github.com/contention/rsync-deployments and https://github.com/jaredpalmer/github-actions-rsync



## Environment variables

| Variable           | Description                                                                                                                      |
|--------------------|----------------------------------------------------------------------------------------------------------------------------------|
| `SSH_PRIVATE_KEY`  | The private key part of an SSH key pair. The public key part should be added to the `authorized_keys` on the destination server. |
| `SSH_USERNAME`     | The username to use when connecting to the destination server                                                                    |
| `SSH_HOSTNAME`     | The hostname of the destination server                                                                                           |

## Required arguments

| Argument           | Description                                                                                                                                          |
|--------------------|------------------------------------------------------------------------------------------------------------------------------------------------------|
| `RSYNC_OPTIONS`    | Rsync-specific options when running the command. Exclusions, deletions, etc                                                                          |
| `RSYNC_TARGET`     | Where to deploy the files on the server                                                                                                              |
| `RSYNC_SOURCE`     | What files to deploy from the repo (starts at root) **NOTE**: a trailing `/` deploys the _contents_ of the directory instead of the entire directory |



# How to use example

```yaml
name: Deploy application

# Controls when the action will run. Triggers the workflow on push events but only for the master branch
on:
  push:
    branches: [ master ]

# A workflow run is made up of one or more jobs that can run sequentially or in parallel
jobs:
  deploy:
  
  # The type of runner that the job will run on
    runs-on: self-hosted
    
    strategy:
      matrix:
        node-version: [14.x]

    # Steps represent a sequence of tasks that will be executed as part of the job
    steps:
    # Checks-out your repository under $GITHUB_WORKSPACE, so your job can access it
	- name: Checkout code
    - uses: actions/checkout@v2
      
    # Runs a single command using the runners shell
    - name: Run a one-line script
      run: echo Deploying the application
      
    - name: Use Node.js ${{ matrix.node-version }}
      uses: actions/setup-node@v1
      with:
        node-version: ${{ matrix.node-version }}
    - run: npm test
      
    - name: Install npm dependencies
      run: npm install
    - name: Run build task
      run: npm run build --if-present

	- name: Deploy to server via rsync
	uses: actions/streembit/apps-deploy-action@@master
	with:
		RSYNC_OPTIONS: -avzr --delete --exclude node_modules --exclude '.git*'
		RSYNC_TARGET: /path/to/target/folder/on/server
		RSYNC_SOURCE: /src/public/
	env:
		SSH_PRIVATE_KEY: ${{secrets.SSH_PRIVATE_KEY}}
		SSH_USERNAME: ${{secrets.SSH_USERNAME}}
		SSH_HOSTNAME: ${{secrets.SSH_HOSTNAME}}
	  
```


