XINTRINSIC 
cross(X)-linear polarization enhanced INTRINSIC imaging 
website testing
# Introduction 
**XINTRINSIC (cross-linear [X] polarization enhanced INTRINSIC imaging)** is an imaging approach developed to image through the intact skull in awake marmoset monkeys and obtain detailed functional maps in the cortex. XINTRINSIC is developed and maintained by Xindong Song from the [Auditory Neurophysiology Laboratory (Wang Lab)](https://wanglab.johnshopkins.edu/lab/WangLabWebsite/index.html) in Johns Hopkins. The current webpage shows a list of code repositories, design notes, and a detailed part list for the ease to replicate our approach. Discussions, questions, and comments are welcome through the [GitHub Issues Tab](https://github.com/x-song-x/XINTRINSIC/issues).

# System Design Notes
For the detailed part list and design notes, please visit my OneNote Notebook:
<iframe src="https://onedrive.live.com/embed?cid=0B62C29AB2D2652F&resid=B62C29AB2D2652F%21278772&authkey=ADcZ35g6KBcWFqI" width="98" height="120" frameborder="0" scrolling="no"></iframe>

# Code
XINTRINSIC recording and analysis routines are implemented in Matlab
- The following code repositories are needed for XINTRINSIC recording
  - [XINTRINIC](https://github.com/x-song-x/XINTRINSIC): the main function
  - [ChKShared](https://github.com/x-song-x/ChKshared): a collection of shared functions with other projects
- The following code repositories are needed for XINTRINSIC synced stimulation delivery & data analysis routines
  - [fluffy-goggles](https://github.com/x-song-x/fluffy-goggles): 
    - XinStimEx: the synchronized stimulation delivery (Visual & Tactile, XINTRINSIC itself can deliver Auditory stimuli)
    - XinProc: the analysis routine

# Discussions and Questions Are Welcome 
Please visit our project discussion panel [here](https://github.com/x-song-x/XINTRINSIC/discussions)
