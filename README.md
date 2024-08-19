##### WANT TO HELP? CLICK THE ★ (STAR LOGO) in the Upper-Right! 

<p align="left">
  <img src="https://i.imgur.com/XI1WGxi.png" alt="Menu Example" width="15%">
</p>

## PlexGuide Installation

Visit the [PlexGuide Installation Information](https://github.com/plexguide/PlexGuide.com/wiki/PlexGuide-Install-Information) area for more detailed information. 

## PlexGuide Wiki 
The [Wiki](https://github.com/plexguide/PlexGuide.com/wiki) will also provide more information in regards to docker, applications, and much more!

### Quick Instatllation Command

```bash
sudo apt-get update -y && sudo apt-get install -y curl git && curl -o /tmp/install.sh https://raw.githubusercontent.com/plexguide/PlexGuide.com/v11/mods/install/install.sh && chmod +x /tmp/install.sh && /tmp/install.sh && chmod +x /pg/scripts/menu.sh && /pg/scripts/menu.sh
```

### Working on PG11

* Simple, debloated, no fancy menus and executes for exactly what you need!
* Very early beta and this will take awhile
* To Test (Use Ubuntu or Debian) CMD Line: 

Quick Notes:
1. Once installed, type pg or plexguide <<<

<p align="center">
  <img src="https://i.imgur.com/tuJpsTR.jpeg" alt="Menu Example" width="65%">
</p>
<p align="center">
  <img src="https://i.imgur.com/M7G2LLl.jpeg" alt="Plex Example" width="65%">
</p>
<p align="center">
  <img src="https://i.imgur.com/goozBTI.jpeg" alt="Plex Example" width="65%">
</p>
<p align="center">
  <img src="https://i.imgur.com/WkEyL9D.jpeg" alt="Plex Example" width="65%">
</p>

----
Status: Early Beta - Works

**Tested On:**  
- Ubuntu 22 Desktop  
- Ubuntu Server 24 LTS

**<span style="color:green">Deployable Apps:</span>**  
Jacket, JellyFin, Lidarr, NetData, NZBGET, Overseer, Ombi, SABNZBD, Plex, Prowlarr, Radarr, Sonarr, UpTimeKuma

### **Current Functionality**

- **Advanced Configuration of App Variables**: Allows for detailed customization of app settings.
- **Port Management**: Easily expose or close ports as needed.
- **CloudFlare Tunnel Integration**: Seamlessly integrates CloudFlare Tunnel for secure access.
- **Port and AppData Management**: Change app ports and AppData locations.
- **Quick Reinstall/Update of PG Beta**: Streamlined process for reinstalling or updating to the latest PG Beta.
- **SSH Installer/Manager**: Added for easy SSH management.

### **In Progress**

- [ ] Enable Personal Apps from Personal Repo  
- [ ] Install GPU Drivers & Add-ons to Apps  
- [ ] Incorporate MergerFS to Merge Multiple Local Drives (Main Focus)  
- [ ] Incorporate CloudDrives (Secondary Focus)  
- [ ] AppData Backup & Restore  
- [ ] Enable Updates to Provide Alpha, Beta, and Stable Builds  
- [ ] Add More Applications  
- [ ] Create Detailed Wiki
