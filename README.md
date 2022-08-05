# Docker image & algorithm submission for Category 2 of SurgToolLoc Challenge 2022

This repository has everything you and your team need to make an algorithm submission for the [SurgToolLoc Challenge](https://surgtoolloc.grand-challenge.org/) Category 2.

Be sure that you have a verified account on Grand Challenge and are accepted as a participant in the SurgToolLoc challenge.
You should be able to submit your Docker container/algorithm on the challenge website when the submission opens.

Here are some useful documentation links for your submission process:
- [Tutorial on how to make an algorithm container on Grand Challenge](https://grand-challenge.org/blogs/create-an-algorithm/)
- [Docker documentation](https://docs.docker.com/)
- [Evalutils documentation](https://evalutils.readthedocs.io/)
- [Grand Challenge documentation](https://comic.github.io/grand-challenge.org/algorithms.html)

## Prerequisites

You will need to have [Docker](https://docs.docker.com/) installed on your system. We recommend using Linux with a Docker installation. If you are on Windows, please use [WSL 2.0](https://docs.microsoft.com/en-us/windows/wsl/install).

## Prediction format

For category 2 of [SurgToolLoc Challenge](https://surgtoolloc.grand-challenge.org/) (surgical tool detection) the instructions to generate the Docker container are given below

### Category #2 – Surgical tool detection:  

The output json file needs to be a dictionary containing the set of tools detected in each frame with its correspondent bounding box corners (x, y), again generating a single json file for each video like given below:  

```
{ 
    "type": "Multiple 2D bounding boxes", 
    "boxes": [ 
        { 
        "corners": [ 
            [ 92.66666412353516, 136.06668090820312, 0.50], 
            [ 54.79999923706055, 136.06668090820312, 0.5], 
            [ 54.79999923706055, 95.53333282470703, 0.5], 
            [ 92.66666412353516, 95.53333282470703, 0.5] 
        ], 
        "name": "slice_nr_1_needle_driver" 
        }, 
        { 
        "corners": [ 
            [ 92.66666412353516, 136.06668090820312, 0.5], 
            [ 54.79999923706055, 136.06668090820312, 0.5], 
            [ 54.79999923706055, 95.53333282470703, 0.5], 
            [ 92.66666412353516, 95.53333282470703, 0.5] 
        ], 
        "name": "slice_nr_2_monopolar_curved_scissor" 
        } 
    ], 
    "version": { "major": 1, "minor": 0 } 
} 
```
 Please note that the third value of each corner coordinate is not necessary for predictions but must be kept 0.5 always to comply with the Grand Challenge automated evaluation system (which was built to also consider datasets of 3D images). To standardize the submissions, the first corner is intended to be the top left corner of the bounding box, with the subsequent corners following the clockwise direction. The “type” and “version” entries are to comply with grand-challenge automated evaluation system. 


## Adapting the container to your algorithm

1. First, clone this repository:

```
git clone https://github.com/aneeqzia-isi/surgtoolloc2022-category-2.git
```

2. Our `Dockerfile` should have everything you need, but you may change it to another base image/add your algorithm requirements if your algorithm requires it:

![Alt text](README_files/dockerfile_instructions.png?raw=true "Flow")

3. Edit `process.py` - this is the main step for adapting this repo for your model. This script will load your model and corresponding weights, perform inference on input videos one by one along with any required pre/post-processing, and return the predictions of surgical tool classification as a dictionary. The class Surgtoolloc_det contains the predict function. You should replace the dummy code in this function with the code for your inference algorihm. Use `__init__` to load your weights and/or perform any needed operation. We have added `TODO` on places which you would need to adapt for your model

4. Run `build.sh`  to build the container. 

5. In order to do local testing, you can edit and run `test.sh`. You will probably need to modify the script and parts of `process.py` to adapt for your local testing. The main thing that you can check is whether the output json being produced by your algorithm container at ./output/surgical-tools.json is similar to the sample json present in the main folder (also named surgical-tools.json).

 PLEASE NOTE: You will need to change the variable `execute_in_docker` to False while running directly locally. But will need to switch it back once you   are done testing, as the paths where data is kept and outputs are saved are modified based on this boolean. Be aware that the output of running test.sh, of course, initially may not be equal to the sample predictions we put there for our testing. Feel free to modify the test.sh based on your needs.

5. Run `export.sh`. This script will will produce `surgtoolloc_det.tar.gz` (you can change the name of your container by modifying the script). This is the file to be used when uploading the algorithm to Grand Challenge.

## Uploading your container to the grand-challenge platform

1. Create a new algorithm [here](https://grand-challenge.org/algorithms/create/). Fill in the fields as specified on the form.

2. On the page of your new algorithm, go to `Containers` on the left menu and click `Upload a Container`. Now upload your `.tar.gz` file produced in step 5. **We will not accept submissions of containers linked to a GitHub repo.**

3. After the Docker container is marked as `Ready`, you can try out your own algorithm when clicking `Try-out Algorithm` on the page of your algorithm, again in the left menu.

4. Now, we will make a submission to one of the test phases. Go to the [SurgToolLoc Challenge](https://surgtoolloc.grand-challenge.org/) and click `Submit`. Under `Algorithm`, choose the algorithm that you just created. Then hit `Save`. After the processing in the backend is done, your submission should show up on the leaderboard if there are no errors.

The figure below indicates the step-by-step of how to upload a container:

![Alt text](README_files/MICCAI_surgtoolloc_fig.png?raw=true "Flow")

If something does not work for you, please do not hesitate to [contact us](mailto:isi.challenges@intusurg.com) or [add a post in the forum](https://grand-challenge.org/forums/forum/endoscopic-surgical-tool-localization-using-tool-presence-labels-663/). 

## Acknowledgments

The repository is greatly inspired and adapted from [MIDOG reference algorithm](https://github.com/DeepPathology/MIDOG_reference_docker), [AIROGS reference algorithm](https://github.com/qurAI-amsterdam/airogs-example-algorithm) and [SLCN reference algorithm](https://github.com/metrics-lab/SLCN_challenge)

