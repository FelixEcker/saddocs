# saddocs
A tool to batch-convert all .sad files in a directory to html.

## Usage
`saddocs [options]`

**Options:**

| Option    | Description    |
| --- | --- |
| --help |    Display a Help text |
| -o     |    Specify the output directory (default ./html) |
| -i     |    Specify the input direcotry (default .) | 
| -r     |    Convert in recursive mode. Converts all sad files in all subdirectories. The same directory structure will be carried over to the output directory |

## Building
saddocs requires the fpc compiler of version 3.2.2 or newer. If it is on the path you may simply execute the build.sh script.

To include debugging symbols simply add `debug` as a parameter to the script.

## Licenses
saddocs uses the uSADParser and uSADHTML units from [sad](https://github.com/FelixEcker/sad), which is licensed under the BSD 3-Clause license.

saddocs is lincensed under the BSD 3-Clause license, see the LICENSE file in this repository.

