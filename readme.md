# Archetype Launcher

The **Archetype Launcher** is a PowerShell-based tool designed to streamline the creation and management of backend and frontend projects. It automates tasks such as cloning boilerplate repositories, initializing Git, creating GitHub repositories, and running backend and frontend applications.

## Features

- **Project Creation**:
  - Automatically clones boilerplate repositories for backend and frontend projects.
  - Initializes Git repositories and pushes the initial commit to GitHub.
  - Supports creating both backend and frontend projects simultaneously.

- **Project Execution**:
  - Runs backend and frontend applications with a single command.
  - Installs frontend dependencies automatically.

## Prerequisites

Before using the Archetype Launcher, ensure the following tools are installed and configured:

- [PowerShell](https://learn.microsoft.com/en-us/powershell/)
- [Git](https://git-scm.com/)
- [GitHub CLI (gh)](https://cli.github.com/)
- [Python](https://www.python.org/) (for backend projects)
- [Node.js](https://nodejs.org/) and npm (for frontend projects)

## Usage

### 1. Clone the Repository

Clone this repository to your local machine:

```bash
git clone https://github.com/YourUsername/archetype-launcher.git
cd archetype-launcher
```

### 2. Run the Script

The main script is `arquetype-launcher.ps1`. Use the following commands to create or run projects.

#### Create a Project

To create a new project, use the `create` order:

```powershell
arquetype-launcher.ps1 -Order create -ProjectName "MyProject" -GitHubUser "YourGitHubUsername" -FrontToo
```

- `-Order create`: Specifies that you want to create a project.
- `-ProjectName`: The name of your project.
- `-GitHubUser`: Your GitHub username.
- `-FrontToo`: (Optional) Includes frontend project creation.

#### Run a Project

To run an existing project, use the `run` order:

```powershell
arquetype-launcher.ps1 -Order run -ProjectName "MyProject"
```

- `-Order run`: Specifies that you want to run a project.
- `-ProjectName`: The name of your project.

### 3. Helper Scripts

The launcher uses helper scripts for specific tasks:

- **`helpers-creation.ps1`**: Handles project creation, Git initialization, and GitHub repository setup.
- **`helpers-run.ps1`**: Handles running backend and frontend applications.

## Example Workflow

1. Create a new project:

   ```powershell
   .\arquetype-launcher.ps1 -Order create -ProjectName "MyApp" -GitHubUser "YourGitHubUsername" -FrontToo
   ```

2. Navigate to the project directory and start coding.

3. Run the project:

   ```powershell
   .\arquetype-launcher.ps1 -Order run -ProjectName "MyApp"
   ```

## Configuration

The script uses default boilerplate repository URLs for backend and frontend projects:

- Backend: `https://github.com/DavidGCalles/Back-Arquetipo.git`
- Frontend: `https://github.com/DavidGCalles/Front-Arquetipo.git`

You can override these defaults by providing custom URLs using the `-BackendBoilerplateRepoUrl` and `-FrontendBoilerplateRepoUrl` parameters.

## Troubleshooting

- Ensure all prerequisites are installed and available in your system's PATH.
- If GitHub CLI is not authenticated, run `gh auth login` to log in.
- Check for typos in the project name or GitHub username.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Feel free to submit issues or pull requests to improve the Archetype Launcher.

## Contact

For questions or support, contact [David G. Calles](https://github.com/DavidGCalles).