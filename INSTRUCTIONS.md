# Instructions for Setup Locally

## Cloning MTG Repo
    * Do NOT clone this repo within our repo. You can clone it in another directory to keep as reference
    * This is because combining our two repositories would be difficult and cause issues

## Setting Up The Virtual Environment
    * to create a .venv run --> uv sync
    * Can install uv here: https://docs.astral.sh/uv/getting-started/installation/

## Run ./scripts/download_sample.sh
    * This will create the data/melspecs directory and download the melspectrograms from the MTG into this folder
    * DOing this to keep repository clean and not crash github because the data could get large as we implement

## Repo Layout
    * data/
        * melspecs/ = Mel Spectrograms (.npy) files from the MTG dataset

    * metadata/
        * autotagging_instrument.tsv = tags of which instrument for each mel spectrogram (cross reference the numbers with the tags)
    
    * scripts/
        * download_sample.sh = shell script to download the mel spectrograms into the ./data/melspecs directory (currently downloads 00 and 01, there are more to download which we can use for implementation)
    * src/
        * eda.ipynb = initial setup ipynb for visualizing a mel spectrogram
    
    * pyproject.toml
        * packages and requirements for a uv based venv manager
    
    * uv.lock
        * for uv things

## I am not pushing the data to the github so it doesn't get overloaded. Follow these instructions to set up the environment locally.