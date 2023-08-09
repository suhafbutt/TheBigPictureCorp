# TheBigCorp

Given a file with a list of image URLs, TheBigCorp downloads all the images from their respective URLs mentioned in the source file to the specified destination. The source file can be present on your system or even remotely.

## Getting Started

To successfully install and to start downloading the images, follow the instructions below:

### Prerequisites

For this project to run locally, you will need the following versions of ruby and bundler installed.

- Ruby (version 3.2.2)
- Bundler (version 2.4.18)

### Installation

Once ruby and bundler are installed follow the instructions below

1. Clone this repository.
2. Navigate to the project directory.
3. Run `bundle install` to install dependencies.
4. Restart the termianl (Just to make sure everything was setup correctly)

## Usage

This tool exposes a rake task that can be executed to trigger the download of images from a source file. The rake task takes two argument

- source - path/URL of the source file which consists all the image URLs
- destination (optional) - optinally you can pass where you would want the downloaded images to be placed in your system, if none is provided the downloaded images will be placed in a `tmp` folder within this project

Rake task can be triggered like this

```
rake the_big_picture_corp:download_files["<source_path>", "<destination_path> (optional)"]
```

## Testing

Navigate to the project directory.
Run 'rspec' to run all the test cases.
