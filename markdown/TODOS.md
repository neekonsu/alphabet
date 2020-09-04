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
### Post issue about:
    Running command: bedtools sort -faidx /alphabet/ABC-Enhancer-Gene-Prediction/example_chr22/reference/chr22 -i /alphabet/ABC-Enhancer-Gene-Prediction/example_chr22/ABC_output/Neighborhoods/GeneList.TSS1kb.bed > /alphabet/ABC-Enhancer-Gene-Prediction/example_chr22/ABC_output/Neighborhoods/GeneList.TSS1kb.bed.sorted; mv /alphabet/ABC-Enhancer-Gene-Prediction/example_chr22/ABC_output/Neighborhoods/GeneList.TSS1kb.bed.sorted /alphabet/ABC-Enhancer-Gene-Prediction/example_chr22/ABC_output/Neighborhoods/GeneList.TSS1kb.bed
    Loading coverage from pre-calculated file for Genes.H3K27ac.ENCFF384ZZM.chr22.bam
    Feature H3K27ac completed in 0.025640010833740234
    Loading coverage from pre-calculated file for Genes.DHS.wgEncodeUwDnaseK562AlnRep1.chr22.bam
    Loading coverage from pre-calculated file for Genes.DHS.wgEncodeUwDnaseK562AlnRep2.chr22.bam
    Feature DHS completed in 0.0519099235534668
    Loading coverage from pre-calculated file for Genes.TSS1kb.H3K27ac.ENCFF384ZZM.chr22.bam
    Feature H3K27ac completed in 0.024033546447753906
    Loading coverage from pre-calculated file for Genes.TSS1kb.DHS.wgEncodeUwDnaseK562AlnRep1.chr22.bam
    Loading coverage from pre-calculated file for Genes.TSS1kb.DHS.wgEncodeUwDnaseK562AlnRep2.chr22.bam
    Feature DHS completed in 0.049674034118652344
    Loading coverage from pre-calculated file for Enhancers.H3K27ac.ENCFF384ZZM.chr22.bam
    Traceback (most recent call last):
    File "/alphabet/ABC-Enhancer-Gene-Prediction/src/run.neighborhoods.py", line 97, in <module>
        main(args)
    File "/alphabet/ABC-Enhancer-Gene-Prediction/src/run.neighborhoods.py", line 93, in main
        processCellType(args)
    File "/alphabet/ABC-Enhancer-Gene-Prediction/src/run.neighborhoods.py", line 88, in processCellType
        outdir = args.outdir)
    File "/alphabet/ABC-Enhancer-Gene-Prediction/src/neighborhoods.py", line 197, in load_enhancers
        enhancers = count_features_for_bed(enhancers, candidate_peaks, genome_sizes, features, outdir, "Enhancers", skip_rpkm_quantile, force, use_fast_count)
    File "/alphabet/ABC-Enhancer-Gene-Prediction/src/neighborhoods.py", line 415, in count_features_for_bed
        df = count_single_feature_for_bed(df, bed_file, genome_sizes, feature_bam, feature, directory, filebase, skip_rpkm_quantile, force, use_fast_count)
    File "/alphabet/ABC-Enhancer-Gene-Prediction/src/neighborhoods.py", line 448, in count_single_feature_for_bed
        assert df.shape[0] == orig_shape, "Dimension mismatch"
    AssertionError: Dimension mismatch
    exit status 1
## Soft-TODOs
### Test makeCandidateRegions.py now that shebang points to bash instead of sh