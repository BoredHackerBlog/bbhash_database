# bbhash_database
project that uses radare2 to extract bbhash and adds it to sqlite and lets you do lookups

# Use cases
- find similar functions in diff binaries
- compared stripped binary to an unstripped one
- sample clustering???
- sample diffing???

# Design
Design is pretty simple. Normally I'd use python but I used bash for fun. I use sqlite db with two tables. One to store binary hashes and one to store bbhash and function name. Radare2 is used to extract the bbhash from binary and it's loaded into sqlite.

# Running the project
## Requirements
- sqlite3
- radare2 (follow their github installation commands...)

## running
- download the bash script, run `chmod +x bbhash_db.sh` to make it executable
- create a database by running `./bbhash_db.sh test.db`
- add bbhash from a binary file by running `./bbhash_db.sh add test.db a.out`
- lookup bbhash by running `./bbhash_db.sh lookup test.db YOURHASH`

# Warning
- i'm not doing any error checks or duplication checks
- unsure about performance for bigger binaries or large amount of binaries, i'd assume processing time and insert/lookup time would probably increase

# resources/other notes
- this type of work has been done before i just implemented it with radare2 and sqlite for my purposes. It's not anything new. check the links below:
- https://github.com/joxeankoret/diaphora
- https://hex-rays.com/products/ida/tech/flirt/in_depth/
- https://binary.ninja/2020/03/11/signature-libraries.html
- https://github.com/malware-kitten/r2_windows_zignatures
- https://github.com/FernandoDoming/r2diaphora
- https://cybersecurity.att.com/blogs/labs-research/code-similarity-analysis-with-r2diaphora
- https://www.youtube.com/watch?v=bBqrC70qMkw
- https://github.com/cmatthewbrooks/r2coderec
- https://hurricanelabs.com/blog/reverse-engineer-faster-with-radare2-signatures/
- https://www.sentinelone.com/labs/the-art-and-science-of-macos-malware-hunting-with-radare2-leveraging-xrefs-yara-and-zignatures/
