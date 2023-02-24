#! /bin/bash
#SBATCH --mem=35G
#SBATCH -o ./out/%A.%x.%a.out # STDOUT
#SBATCH -e ./err/%A.%x.%a.err # STDERR
#SBATCH --array=1-456%50
#SBATCH --partition=carter-compute



samples=(SRR6468308 SRR2741956 SRR2673444 SRR2778512 SRR2775071 SRR2766211 SRR2648156 SRR2666252 SRR2648142 SRR480909 SRR2763711 SRR5134885 SRR2771490 SRR3341228 SRR6461148 SRR2764748 SRR479199 SRR6461157 SRR484160 SRR3083854 SRR2587681 SRR2648148 SRR481793 SRR2765463 SRR2648168 SRR2648140 SRR484096 SRR3341208 SRR2779613 SRR3083877 SRR6447677 SRR3083856 SRR3083846 SRR483491 SRR2648124 SRR2774803 SRR3341180 SRR487796 SRR2771231 SRR483555 SRR484937 SRR3341198 SRR2761780 SRR3341222 SRR4289737 SRR2648116 SRR482151 SRR6468337 SRR6447690 SRR6468315 SRR3341196 SRR5134747 SRR3341212 SRR2895608 SRR3083881 SRR3083869 SRR2770768 SRR2724330 SRR3341206 SRR483882 SRR4289729 SRR2698019 SRR2730944 SRR3341244 SRR487819 SRR2771689 SRR4289727 SRR6468323 SRR2780020 SRR6450225 SRR2648146 SRR2587502 SRR5134840 SRR2891891 SRR6468335 SRR6461182 SRR6504841 SRR2740097 SRR6461176 SRR5134798 SRR2763056 SRR2740729 SRR5134877 SRR479153 SRR3083858 SRR6461154 SRR6511549 SRR478918 SRR2731589 SRR5134756 SRR3341190 SRR487624 SRR3341238 SRR484544 SRR2729983 SRR482174 SRR4289739 SRR5134852 SRR3083840 SRR2686494 SRR2663174 SRR484429 SRR5134745 SRR4289731 SRR2772456 SRR3341258 SRR484010 SRR6468338 SRR6504590 SRR5134821 SRR3341170 SRR2698835 SRR2710529 SRR2677014 SRR3083867 SRR2648120 SRR5134825 SRR2747654 SRR2685662 SRR2648130 SRR2662805 SRR2767209 SRR2648158 SRR6468313 SRR2757063 SRR5134822 SRR2712107 SRR484516 SRR3341270 SRR482851 SRR3341178 SRR2648112 SRR2648160 SRR5134829 SRR5134823 SRR3083852 SRR6468304 SRR3341168 SRR5134832 SRR6511550 SRR5134889 SRR5134919 SRR2779751 SRR2776720 SRR3341174 SRR3083838 SRR6447680 SRR6461143 SRR3341216 SRR487451 SRR479337 SRR3341282 SRR2682770 SRR6468334 SRR6461158 SRR3341186 SRR2756594 SRR3341232 SRR4289716 SRR5134767 SRR484723 SRR6450223 SRR3341284 SRR3341288 SRR5134811 SRR3341184 SRR478575 SRR3341278 SRR3083871 SRR3341268 SRR2682026 SRR3341260 SRR487883 SRR3341220 SRR2661956 SRR6504836 SRR3341226 SRR3341254 SRR484615 SRR481943 SRR487429 SRR5134826 SRR479932 SRR6447678 SRR2763956 SRR6468305 SRR2668081 SRR5134874 SRR3341172 SRR2648122 SRR5134768 SRR3341272 SRR483599 SRR3341214 SRR6511548 SRR5134800 SRR6468346 SRR6468322 SRR2763304 SRR6447681 SRR478648 SRR2768161 SRR5134896 SRR3341264 SRR5134901 SRR3341242 SRR3341200 SRR2770971 SRR5134855 SRR3341252 SRR6461156 SRR2766685 SRR487688 SRR2693364 SRR5134814 SRR2779333 SRR2779120 SRR6461161 SRR2776026 SRR2648132 SRR479863 SRR2648126 SRR6461149 SRR2776322 SRR482058 SRR2648104 SRR5134810 SRR6504837 SRR4289722 SRR2588273 SRR2648108 SRR5134806 SRR2767840 SRR3083873 SRR5134915 SRR3083848 SRR4289720 SRR3341250 SRR5134763 SRR483946 SRR3341276 SRR3083842 SRR3341218 SRR2674207 SRR3083864 SRR478621 SRR6468344 SRR6468310 SRR2663870 SRR5134781 SRR2648106 SRR2685939 SRR2780399 SRR6447676 SRR6468309 SRR6504839 SRR5134870 SRR2766529 SRR483089 SRR5134892 SRR3083844 SRR2701132 SRR5134752 SRR3341188 SRR5134791 SRR6461174 SRR6468264 SRR5134902 SRR479245 SRR483023 SRR5134760 SRR5134796 SRR3341234 SRR6461160 SRR487752 SRR4289735 SRR2709391 SRR6461178 SRR484659 SRR2648110 SRR6511552 SRR3083850 SRR2587942 SRR5134920 SRR5134805 SRR2762344 SRR3083875 SRR6504591 SRR6461153 SRR5134850 SRR485087 SRR2648144 SRR6468314 SRR3341182 SRR6468317 SRR481082 SRR2755533 SRR3341176 SRR3341210 SRR6461144 SRR484452 SRR6461179 SRR2779792 SRR3083883 SRR2648128 SRR5134788 SRR6461142 SRR2768007 SRR3341286 SRR3341294 SRR3341248 SRR2739282 SRR3341202 SRR2648150 SRR2777128 SRR5134787 SRR5134831 SRR2770912 SRR5134837 SRR6461151 SRR2776116 SRR487602 SRR5134765 SRR6504584 SRR3341266 SRR2718333 SRR478895 SRR5134912 SRR484809 SRR3341192 SRR3341224 SRR480024 SRR4289724 SRR6468312 SRR2660259 SRR487538 SRR3341262 SRR2648102 SRR487969 SRR3341194 SRR6468319 SRR3341290 SRR5134775 SRR6511553 SRR2665211 SRR6468263 SRR2767000 SRR2681066 SRR3083860 SRR483469 SRR2765167 SRR5134772 SRR2663978 SRR6504585 SRR2722193 SRR2648136 SRR4289714 SRR5134861 SRR2766020 SRR6468342 SRR483067 SRR2660711 SRR5134769 SRR3341292 SRR5134794 SRR5134900 SRR3341256 SRR2648138 SRR5134887 SRR478867 SRR2648134 SRR3341230 SRR481965 SRR4289743 SRR2773005 SRR479268 SRR2648118 SRR5134865 SRR2689026 SRR6461146 SRR6468343 SRR2774871 SRR4289741 SRR2676240 SRR6504587 SRR2771101 SRR2771877 SRR5134854 SRR2648154 SRR5134757 SRR6468303 SRR5134755 SRR2680371 SRR3341280 SRR479130 SRR2769007 SRR482656 SRR479314 SRR2648114 SRR479383 SRR2743785 SRR3341274 SRR484873 SRR2775312 SRR2669737 SRR3341240 SRR6468266 SRR2674183 SRR2776513 SRR3341246 SRR3083862 SRR2778467 SRR483818 SRR6461152 SRR6468340 SRR5134898 SRR478821 SRR482012 SRR2774637 SRR3341204 SRR480955 SRR3341236 SRR2744628 SRR2680027 SRR6447675 SRR2648166 SRR479955 SRR5134893 SRR2648152 SRR2766353 SRR5134815 SRR4289733 SRR5134819 SRR2724351 SRR2669057 SRR487947 SRR4289718 SRR5134809 SRR479840 SRR5134908 SRR2648162 SRR483577 SRR484224 SRR5134780 SRR2696332 SRR2768667 SRR5134797 SRR5134779 SRR5134860 SRR2779541 SRR3083879 SRR6468267 SRR2660402 SRR2648164 SRR478798 SRR6461145)
sample=${samples[$SLURM_ARRAY_TASK_ID-1]}


date

input_dir=/nrnb/users/mpagadal/immunotherapy-trials/normal_wxs/aligned
output_dir=/cellar/users/mpagadal/immunotherapy-trials/data/bams

cd $output_dir

samtools view -b $input_dir/$sample.recal.bam chr1 > $output_dir/$sample.chr1.recal.bam
samtools index $output_dir/$sample.chr1.recal.bam

date
