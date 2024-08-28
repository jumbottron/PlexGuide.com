import os
import json
import requests
import docker

class PersonalAppManager:
    def __init__(self):
        self.config_file = 'personal_apps_config.json'
        self.docker_client = docker.from_env()

    def add_personal_repo(self, repo_url):
        if not os.path.exists(self.config_file):
            config = {'repos': []}
        else:
            with open(self.config_file, 'r') as f:
                config = json.load(f)
        
        if repo_url not in config['repos']:
            config['repos'].append(repo_url)
            with open(self.config_file, 'w') as f:
                json.dump(config, f)
            print(f"Added personal repo: {repo_url}")
        else:
            print(f"Repo {repo_url} already exists.")

    def list_personal_apps(self):
        if not os.path.exists(self.config_file):
            print("No personal repos added yet.")
            return

        with open(self.config_file, 'r') as f:
            config = json.load(f)

        for repo in config['repos']:
            try:
                response = requests.get(f"{repo}/apps.json")
                apps = response.json()
                print(f"Apps available in {repo}:")
                for app in apps:
                    print(f"- {app['name']}: {app['description']}")
            except Exception as e:
                print(f"Error fetching apps from {repo}: {str(e)}")

    def deploy_personal_app(self, app_name):
        if not os.path.exists(self.config_file):
            print("No personal repos added yet.")
            return

        with open(self.config_file, 'r') as f:
            config = json.load(f)

        for repo in config['repos']:
            try:
                response = requests.get(f"{repo}/apps.json")
                apps = response.json()
                app = next((a for a in apps if a['name'] == app_name), None)
                if app:
                    print(f"Deploying {app_name}...")
                    self.docker_client.containers.run(
                        app['image'],
                        name=app_name,
                        detach=True,
                        ports={f"{port}/tcp": port for port in app['ports']}
                    )
                    print(f"{app_name} deployed successfully!")
                    return
            except Exception as e:
                print(f"Error deploying {app_name} from {repo}: {str(e)}")
        
        print(f"App {app_name} not found in any personal repo.")

if __name__ == "__main__":
    manager = PersonalAppManager()
    
    # Example usage:
    # manager.add_personal_repo("https://example.com/my-personal-repo")
    # manager.list_personal_apps()
    # manager.deploy_personal_app("my-custom-app")