# NComp

![ncomp](https://github.com/Ashutosh0602/NComp/assets/85889617/f56844e3-ad97-41c8-bb94-e00d176dc32a)

## Node.js Project Compressor

This project is a shell script designed to compress entire Node.js projects efficiently to save space while maintaining accessibility. It offers several features to manage compressed Node.js projects conveniently.

### Features

1. **Compression**: Compresses entire Node.js projects into archives to save space.
2. **Listing**: Lists all Node.js projects present inside an archive for easy navigation and access.
3. **Decompression**: Unzips compressed folders and restores them to their original locations.

### Usage

#### Compression

To compress a Node.js project directory, execute the following command in the directory which has to be compressed:

```bash
ncomp -c
```

#### Listing

To view all the Node.js projects present inside an archive, use the following command:

```bash
ncomp -l
```

#### Decompression

To unzip a compressed Node.js project directory and restore it to its original location, run:

```bash
ncomp -u <filename>
```

### Requirements

- Unix-like operating system (Linux, macOS, etc.)
- Node.js installed on the system
- Basic understanding of shell scripting

### Installation

1. Clone this repository:

```bash
git clone https://github.com/Ashutosh0602/NComp.git
```

2. Navigate to the cloned directory:

```bash
cd NComp
```

3. Make sure all script files (`main.sh`) are executable:

```bash
make setup
```

### Contribution

Contributions are welcome! If you have any ideas, improvements, or bug fixes, feel free to open an issue or submit a pull request.

### Acknowledgments

- Inspired by the need to efficiently manage and compress Node.js projects.
- Thanks to the open-source community for various utilities and resources utilized in this project.

### Author

[Ashutosh Rai](https://github.com/Ashutosh0602)

### Contact

For any inquiries or suggestions regarding this project, feel free to contact the author at [ashujn2del@gmail.com](mailto:ashujn2del@gmail.com).
