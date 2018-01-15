
# Run pipeline
bsub -q basement -J snake_master -n 2 -o output-%J.txt -e error-%J.txt bsub_wrapper.sh
