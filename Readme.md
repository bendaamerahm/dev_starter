# DevStarter

## Overview

This project automates the setup of a development environment for new developers. It supports various operating systems and configures essential development tools and IDEs based on the developer's role.

## Supported Operating Systems

- Linux (Debian/Ubuntu, CentOS, Fedora, openSUSE)
- MacOS
- Windows (Manual steps recommended)

## Supported Developer Roles

- Backend
- Frontend
- Full-Stack

## Usage

#### dev starter Command
To kickstart your development environment setup, simply run the `dev_starter` command in the root directory of your project. This command initializes the project and prepares all necessary configurations.

```bash
dev_starter [option]
```

#### Options
- `-h, --help`: Display the help message and exit.
- `-u, --usage`: Display detailed usage information.

### Initiate Setup with Options
You can pass options to the `init-dev.sh` script through the `dev_starter` command. For example:

```bash
dev_starter -h
```

This command will display the help message for detailed usage information.

### Extending the Script
To add support for additional tools or languages, modify the script to include installation functions tailored to those requirements. Ensure compatibility with different operating systems and package managers.

### Customization
The script detects the operating system and chooses the appropriate package manager for software installation. For unsupported configurations, manual installation steps are provided.

### Contributing
Contributions to improve the script or extend its capabilities are welcome. Please submit pull requests with your enhancements.

### Troubleshooting
Describe common issues and troubleshooting steps, such as permission errors, unsupported OS versions, or network issues during package downloads.

### Final Thoughts
- **Testing Across Environments:** It's crucial to test the script across different operating systems and distributions to ensure compatibility and identify any issues.
- **Feedback Loop:** Encourage users of the script to provide feedback or report issues. This input is invaluable for iterative improvement.
- **Version Control:** Keep the script and its documentation under version control to track changes, contributions, and issues.

