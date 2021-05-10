# ValidityDocker
Create a docker container that can be used to build and run the Validity (https://validitytech.com/) client.  This is intended to allow an easy way to run the wallet on a Raspberry Pi (recommended Raspberry Pi 4 8GB).

![image](https://user-images.githubusercontent.com/6404377/117683255-e244f680-b181-11eb-97a8-bbd66c0acc58.png)


## Dependencies
* 64-bit OS installed on the Pi (currenlty using Ubuntu 21.04).  Recommended to run off an external USB hard drive and not a SD card.
* Docker installed (https://docs.docker.com/engine/install/).  Note - Docker is included in Ubuntu 21.04.
* x11docker installed (https://github.com/mviereck/x11docker#shortest-way-for-first-installation).

## Usage

### Build the image

Execute `sudo ./buildValidity.sh` to setup a Docker image that does the following:
* Fetch and extract the latest tarball source file from the Validity GitHub
* Setup all build and runtime dependencies for Validity
* Compile the Validity source
* Create a final image tagged as ubuntu/validity:latest, with only the files necessary to launch Validity.
* Note - compilation will take several hours on a Raspberry Pi.

You can execute a `docker system prune` after building to free up space from the intermediate images of the build if desired.

### Run the image

Execute `sudo ./runValidity.sh` to launch a container with the ubuntu/validity image using x11docker with the data folder in the same directory shared as the home folder for the container.  

The first time it is launched the Validity application will prompt for the data folder.  Choosing the default will create a hidden .phore folder inside the shared data folder, and will be used the next time the Validity application is laucned.  

After syncing the blockchain, exit Validity and the x11docker window will close.  If you have an existing wallet.dat file, you can replace the data/wallet.dat file with yours.  Remember to keep your wallet.dat file safe!

### Notes

There are some visual odditities present when using x11docker.  There might be some other settings to play with to help with these, but it is usable as is.

* The title bar is not visibile in the application, meaning the 'X' buttons to close the application or any dialogs are not available.  To close dialogs, the Cancel button or the Esc key can be used.
* When hovering over the connections icon, the tooltip shows the number of connections as "active connections to Bitcoin network" and not "active connections to Validity network" like the Windows client does.
* x11docker has other options that might be useful, such as --clipboard to copy/paste into the Validity window.  Requires xclip: `sudo apg-get install xclip`, and adding --clipboard to the runValidity.sh script.
