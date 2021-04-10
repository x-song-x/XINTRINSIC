XINTRINSIC 
cross(X)-linear polarization enhanced INTRINSIC imaging 
website testing
# Introduction 
**XINTRINSIC (cross-linear [X] polarization enhanced INTRINSIC imaging)** is an imaging approach developed to image through the intact skull in awake marmoset monkeys and obtain detailed functional maps in the cortex. XINTRINSIC is developed and maintained by Xindong Song from the [Auditory Neurophysiology Laboratory (Wang Lab)](https://wanglab.johnshopkins.edu/lab/WangLabWebsite/index.html) in Johns Hopkins. The current webpage shows a list of code repositories, design notes, and a detailed part list for the ease to replicate our approach. Discussions, questions, and comments are welcome through the [GitHub Issues Tab](https://github.com/x-song-x/XINTRINSIC/issues).

# System Design Notes
For the detailed part list and design notes, please visit my OneNote Notebook:

![XINTRINSIC](https://img-prod-cms-rt-microsoft-com.akamaized.net/cms/api/am/imageFileData/RE2yJZy?ver=066d&q=90&h=40&b=%23FFFFFFFF&aim=true) [XINTRINSIC design notes](https://onedrive.live.com/redir.aspx?cid=0b62c29ab2d2652f&resid=B62C29AB2D2652F!278772&parId=B62C29AB2D2652F!104&authkey=!ADcZ35g6KBcWFqI)

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

