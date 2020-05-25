# apps-deploy-action
CI/CD workflow

# Credits
Based on https://github.com/contention/rsync-deployments

# How to use example

```
# Deploy this repository

name: Deploy with rsync

# Controls when the action will run. Triggers the workflow on push or pull request
# events but only for the master branch
on:
  push:
    branches: [ master ]


# A workflow run is made up of one or more jobs that can run sequentially or in parallel
jobs:
  # This workflow contains a single job called "build"
  build:
    # The type of runner that the job will run on
    runs-on: self-hosted
    
    strategy:
      matrix:
        node-version: [14.x]

    # Steps represent a sequence of tasks that will be executed as part of the job
    steps:
    # Checks-out your repository under $GITHUB_WORKSPACE, so your job can access it
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

    - name: Deploy to Server
      uses: actions/streembit/apps-deploy-action@v1
      env: 
        DEPLOY_KEY: ${{secrets.DEPLOY_KEY}} 
      with: 
        args: "-avzr --delete [ssh_user_name]@[remote_web_server]:/[destination_directory]/"

```

