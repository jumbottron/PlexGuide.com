##### WANT TO HELP? CLICK THE ★ (STAR LOGO) in the Upper-Right! 

<p align="left">
  <a href="https://discord.gg/Uruj9Ds5">
    <img src="https://i.imgur.com/XI1WGxi.png" alt="Menu Example" width="15%">
  </a>
</p>

## PlexGuide Installation

Visit the [PlexGuide Installation Information](https://github.com/plexguide/PlexGuide.com/wiki/PlexGuide-Install-Information) area for more detailed information. 


## PlexGuide Wiki 
The [Wiki](https://github.com/plexguide/PlexGuide.com/wiki) will also provide more information in regards to docker, applications, and much more!

### Quick Install Command

```bash
sudo apt-get update && sudo apt-get install -y curl && bash <(curl -s https://raw.githubusercontent.com/plexguide/PlexGuide.com/v11/mods/scripts/install_menu.sh)
```

### Working on PG11

* Simple, debloated, no fancy menus and executes for exactly what you need!
* Tested on UB 22/24 Server LTS (should work on Debian, but not tested)
* To Test (Use Ubuntu or Debian) CMD Line; once installed, type `pg` or `plexguide`

<p align="center">
  <table align="center">
    <tr>
      <td align="center"><img src="https://i.imgur.com/HzCKvO5.jpeg" alt="Menu Example" width="500"></td>
      <td align="center"><img src="https://i.imgur.com/pu1D9Cc.jpeg" alt="Plex Example" width="500"></td>
    </tr>
    <tr>
      <td align="center"><img src="https://i.imgur.com/goozBTI.jpeg" alt="Plex Example" width="500"></td>
      <td align="center"><img src="https://i.imgur.com/WkEyL9D.jpeg" alt="Plex Example" width="500"></td>
    </tr>
  </table>
</p>

----

**<span style="color:green">Deployable Apps:</span>**  
FireFox, Jackett, JellyFin, Lidarr, NetData, NZBGET, Overseer, Ombi, Opera, Plex, Prowlarr, QBittorent, Radarr, TdarrServer, TdarrNodes, SABNZBD, Sonarr, Ungoogled Chromium, UpTimeKuma, VaultWarden

### **Current Functionality**

- **Advanced Configuration of App Variables**: Allows for detailed customization of app settings.
- **Port Management**: Easily expose or close ports as needed.
- **CloudFlare Tunnel Integration**: Seamlessly integrates CloudFlare Tunnel for secure access.
- **Port and AppData Management**: Change app ports and AppData locations.
- **Quick Reinstall/Update of PG Beta**: Streamlined process for reinstalling or updating to the latest PG Beta.
- **SSH Installer/Manager**: Added for easy SSH management.
- **Intel/NVIDIA GPU Manager**: Install / Uninstall GPU Drivers easily.
- **Firewall Port Security**: View open ports; close and open additional ports
- **Dynamic Menu Intergration**: Enables custom options for docker containers
- **Streamlined Updating**: PG Alpha and Beta Builds Intergrated. Stable will be added later
- **Personal Apps Management**: Add and deploy apps from personal repositories
- **MergerFS Integration**: Merge multiple local drives into a single pool
- **Cloud Drives Management**: Set up and manage cloud storage solutions

### **In Progress**

- [x] Enable Personal Apps from Personal Repo  
- [x] Incorporate MergerFS to Merge Multiple Local Drives (Main Focus)  
- [x] Incorporate CloudDrives (Secondary Focus)  
- [ ] AppData Backup & Restore  
- [ ] Add More Applications  
- [ ] Create Detailed Wiki
- [ ] Deployment of PlexDebrid/Zurg
- [ ] VPN Server Capabilities

### **Recently Completed**

- [x] Enable Personal Apps from Personal Repo
  - Added `personal_apps.sh` script to manage personal apps
  - Users can now add personal repositories, list available apps, and deploy personal apps
  - To use, run `bash personal_apps.sh` and follow the menu options

- [x] Incorporate MergerFS to Merge Multiple Local Drives
  - Added `mergerfs_setup.sh` script to manage MergerFS setup
  - Users can now easily merge multiple local drives into a single pool
  - To use, run `bash mergerfs_setup.sh` and follow the menu options

- [x] Incorporate CloudDrives
  - Added `cloud_drives_setup.sh` script to manage cloud storage solutions
  - Features include:
    - Installation and updating of rclone
    - Configuration of various cloud providers (Google Drive, OneDrive, Dropbox, etc.)
    - Mounting and unmounting of cloud drives
    - Integration with MergerFS for unified storage
    - Automatic mounting on system startup
    - Logging and status checking of cloud drive mounts
  - To use, run `bash cloud_drives_setup.sh` and follow the menu options

We welcome contributions and feedback on these features. If you're interested in helping with any of these tasks, please check our [contribution guidelines](link-to-contribution-guidelines) or join our [Discord community](https://discord.gg/Uruj9Ds5) for more information.
