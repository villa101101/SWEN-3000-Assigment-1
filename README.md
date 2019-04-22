
# SWEN 3000 Assigment 1

## FileExplorer

1. Create a github account, and `fork` this project.


2. Clone the forked repostories with `git` locally

You can try `git` in command line with Terminal.app

    git clone https://github.com/[YOUR_GITHUB_ID]/SWEN-3000-Assigment-1.git

3. Open the Terminal, run the server

Install tornado

    pip install tornado

If you have python2.7 and there is no `pip` command, try this

    sudo easy_install pip
    sudo pip install tornado

Run `web.py` script

    python server/web.py
    
Make sure the web API service is available at port 8000

4. Test the API by visiting the address in web browser

        http://127.0.0.1:8000/?folder=[FOLDER_NAME]

The API return format in JSON as a dictionary

    {
        "folders": ["folder1", "folder2"],
        "files": ["file1", "file2"],
        "current": "[CURRENT_FOLDER_NAME]",
        "parent": "[PARENT_FOLDER_NAME]",
    }

When `current` is equal to `parent` and they are both empty string, it means we are already at the root folder.

5. Open Xcode and build the FileExplorer


