##### WANT TO HELP? CLICK THE ★ (STAR LOGO) in the Upper-Right! 

Working on PG11

* Simple, debloated, no fancy menus and executes for exactly what you need!
* Very early beta and this will take awhile
* To Test (Use Ubuntu or Debian) CMD Line: 

```bash
sudo apt-get update -y && sudo apt-get install -y curl git && curl -o /tmp/install.sh https://raw.githubusercontent.com/plexguide/PlexGuide.com/v11/mods/install/install.sh && chmod +x /tmp/install.sh && /tmp/install.sh && chmod +x /pg/scripts/menu.sh && /pg/scripts/menu.sh
```

Quick Notes:
1. Once installed, type pg or plexguide <<<

<p align="center">
  <img src="https://i.imgur.com/yhBCIl6.jpeg" alt="Menu Example" width="65%">
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

Stuff below is old and dataed and not relevant. Update will be done when completed.

----
Status: Early Beta - Works

**<span style="color:green">Deployable Apps:</span>** Jacket, JellyFin, Lidarr, NetData, NZBGET, Overseer, Ombi, SABNZBD, Plex, Prowlarr, Radarr, Sonarr, UpTimeKuma

Currently Works:

- Advanced Configuration of App Variables
- Expose/Close Ports
- CloudFlare Tunnel works perfectly
- Change Port and AppData Location
- Quick Reinstall/Update of PG Beta (will be more advanced)

Working On:

[ ] Enable Personal Apps from Personal Repo  
[ ] Install GPU Drivers & Add on to apps  
[ ] Incorporate MergerFS to merge multiple local drives < main focus  
[ ] Incorporate CloudDrives < secondary focus  
[ ] AppData Backup & Restore  
[ ] Enable Update to provide Alpha, Beta, and Stable Builds  
[ ] Add More Applications 
[ ] Add SSH Script to turn off/on and change ports 
[ ] Create Detailed Wiki

----

## 1. PG YouTube

<p align="center"><kbd><a href="https://youtu.be/joqL_zjl0pE" /a><img src="https://github.com/PGBlitz/Assets/blob/master/ycovers/mainintro.png" width="400"></kbd></p>
<p align="center"><b>PGBlitz Introduction Video</b></p>

<p align="center"><kbd><a href="https://youtu.be/8lotdbpsrUE" /a><img src="https://github.com/PGBlitz/Assets/blob/master/ycovers/introv10.png" width="400"></kbd></p>
<p align="center"><b>PlexGuide Installation Video</b></p>

[**[Click Here]**](https://pgblitz.com/threads/plexguide-install-instructions.243/) for installation instructions to start the process

## 2. Project Statement

<p align="center"><b>Manage PlexGuide - AnyTime, Anywhere!</b></p>

**Project Statement:** PlexGuide is an all-in-one media solution that deploys a Media Server through the use of your Local HD or Google Drive; serving as an unlimited back-end storage. PGBlitz utilizes Ansible and Docker to streamline your Media Server, while deploying multiple tools for your Server Operations.

## 3. Functional Use

1. Deploys multiple programs/app and functional within 10 - 30 seconds
1. Deploy PlexGuide on a remote machine, local machine, VPS, or virtual machines
1. Deploy PlexGuide utilizing Google's GSuite for unlimited space or through the solo or multiple HD editions
1. Deploys a Reverse Proxy (Traefik) so you can obtain https:// certificates on all your containers
1. Backup and Restore data through your Google Drive
1. Aligns data and ports for efficiency
1. Deploys with a simple installer and a GUI like interface (commands do not have to be typed out)
