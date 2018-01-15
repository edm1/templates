# clone workflow into working directory
git clone https://bitbucket.org/user/myworkflow.git path/to/workdir
cd path/to/workdir

# edit config and workflow as needed
vim config.yaml

# install dependencies into isolated environment
conda env create -n <project> --file environment.yaml

# activate environment
source activate <project>

# execute workflow
snakemake -n
