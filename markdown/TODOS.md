# TODOS
## Mandatory
### Debug makeCandidateRegions.py
### Post issue to ABC-Enhancer-Gene-Prediction about following printout from compute_powerlaw_fit_from_hic.py
    Setting working directory to /alphabet/ABC-Enhancer-Gene-Prediction
    Starting chr22 ... 
    java -jar /alphabet/juicer_tools.jar dump observed KR https://hicfiles.s3.amazonaws.com/hiseq/k562/in-situ/combined_30.hic 22 22 BP 5000 /alphabet/ABC-Enhancer-Gene-Prediction/example_chr22/input_data/HiC/raw/chr22/chr22.KRobserved
    java -jar /alphabet/juicer_tools.jar dump norm KR https://hicfiles.s3.amazonaws.com/hiseq/k562/in-situ/combined_30.hic 22 BP 5000 /alphabet/ABC-Enhancer-Gene-Prediction/example_chr22/input_data/HiC/raw/chr22//chr22.KRnorm
    Using: /alphabet/ABC-Enhancer-Gene-Prediction/example_chr22/input_data/HiC/raw/chr22/chr22.KRobserved.gz
    Working on /alphabet/ABC-Enhancer-Gene-Prediction/example_chr22/input_data/HiC/raw/chr22/chr22.KRobserved.gz
    Loading HiC
    hic.to.sparse: Elapsed time: 0.43698692321777344
    HiC Matrix has row sums of 2462.539801718806, making doubly stochastic...
    /alphabet/ABC-Enhancer-Gene-Prediction/src/hic.py:141: RuntimeWarning: invalid value encountered in less
    norms[norms < kr_cutoff] = np.nan
    /alphabet/ABC-Enhancer-Gene-Prediction/src/hic.py:142: RuntimeWarning: invalid value encountered in greater_equal
    norms[norms >= kr_cutoff] = 1
    HiC has 843068 rows after windowing between 5000 and 1000000
    process.hic: Elapsed time: 0.6108150482177734
    Running regression
    Verifying arguments for 'macs2 callpeak'
## Soft-TODOs
### Test makeCandidateRegions.py now that shebang points to bash instead of sh 