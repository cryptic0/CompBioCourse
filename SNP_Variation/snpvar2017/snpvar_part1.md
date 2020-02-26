# Human Population Genomic Variation 
## Variants (SNPs) in *LCT* Gene: Part 1
### Molb 4485/5485 -- Computers in Biology ##

### Vikram Chhatre and Nicolas Blouin ####
Wyoming INBRE Bioinformatics Core  
Dept. of Molecular Biology  
University of Wyoming  

[vchhatre@uwyo.edu](mailto:vchhatre@uwyo.edu)   
[nblouin@uwyo.edu](mailto:nblouin@uwyo.edu)  
[http://molb4485.uwyo.online](http://molb4485.uwyo.online)  
<hr> 



<img src="hg.jpg" width=800></a>
Hunting and Gathering to Pastoralism. Image Credit: [Dan Burr](http://dburr.blogspot.com) 


<h3 style="color: red;"> Important: </h3> 

**1. Do not race ahead in the tutorial.**  

**2. Doing so compromises your learning experience.** 

**3. You may not leave early today!**
<br><br><br>

## Table of Contents
1. [Exercise Data](#data)
2. [Variant Call Format](#vcf)
3. [Gene Frequency](#freq)


<br><br><br><br><br>

<a name="data"></a>

### 1. Data For Today's Exercise  ###


For this entire exercise, replace ``[inbreNNN]`` with your own ``inbre`` ID.  Once you log on to Mt. Moran, copy the data for today's exercise as follows.

```bash
$ ssh [inbreNNN]@mtmoran.uwyo.edu

$ cd /project/inbre-train/[inbreNNN]/

$ mkdir Week5 && cd Week5/

$ cp -r /project/inbre-train/Week5Data/* .

$ ls -l


```


<a name="vcf"></a>

### 2. Variant Call Format (VCF) spec. 4.1

This is a standard for storing information on polymorphism in genes. It is a ``n x n`` matrix of individuals and variants. Columns refer to individuals, whereas rows refer to variants (SNPs). Analogous to the FASTQ format, VCF also stores quality information. Files formatted to store variant calls always end in ``.vcf`` extension. For example: ``input.vcf``. The VCF format is described in detail in the user manual available at [http://samtools.github.io](http://samtools.github.io).


#### 2.1 VCFTools

VCFTools is a program that can report information on and manipulate the .vcf files. A compre- hensive manual on VCFTools usage is [available here](http://vcftools.sourceforge.net/man latest.html). Before we can use this program, we must load it in memory as a module.


```bash

$ module spider vcftools

$ module load intel perl vcftools

$ vcftools

VCFtools (0.1.15)
    Adam Auton and Anthony Marcketta 2009


```


#### 2.2 VCF File

We have provided you with an example ``.vcf`` file for today’s exercise: ``human_chr2.vcf``. As the name suggests, this file contains data from *Homo sapiens* ``CHROMOSOME 2``. The data was collected as part of the [1000 Genomes Project](http://www.internationalgenome.org) whose aim is to understand human genomic variation across the globe. This data is from the final phase of the project and contains genotypes of ~2500 individuals from 26 populations distributed globally genotyped at more than 84 million SNPs.

To make it more manageable, we have subset the original data to only include information on 1000 SNPs. You will be further subsetting this file to obtain data on one specific SNP that we are interested in. But for now, open the file in text editor and take a look at the contents. Then close the file without saving.


```bash

$ vim human_chr2.vcf

[vim] :set nowrap
[vim] :wq

```
#### 2.3 VCF Data Summary

VCFTools can provide a quick summary of your data.  When running without any options, VCFTools outputs summary statistics but does not make any changes to the file nor does it produce any output files.

```bash

$ vcftools --vcf human_chr2.vcf

VCFtools - 0.1.15
   (C) Adam Auton and Anthony Marcketta 2009

   Parameters as interpreted:
           --vcf human_chr2.vcf

   After filtering, kept 2504 out of 2504 Individuals
   After filtering, kept 1000 out of a possible 1000 Sites

   Run Time = 0.00 seconds

```


#### 2.4 SNP ``rs34100645``

For today's exercise, we are interested in only one SNP: ``rs776746``. Every documented SNP from the human genome has a ``rs`` ID associated with it. Note that the number following rs, is not the physical position of this SNP on a chromosome, but simply an identifier. You can look up the physical position of this SNP in the VCF file. For example:

```bash

$ grep "rs34100645" human_chr2.vcf | cut -f1-5

2	135805941	rs34100645	A	T

```

Why did we pass the output of grep to cut via a ``|``? It's because when grep matches a pattern, it prints the entire line to the screen. Our lines here have more than 2500 columns and we are only interested in the first few columns as displayed above.

This is one of more than 1000 SNPs present within the sequence of gene *LCT* or Lactose Persistence.  One of the alleles at this mutation (SNP) has a very small contribution to the ability of digesting lactose sugar present in the milk.  Thus, we are interested in the frequency of this allele in various human populations.


#### 2.5 Subset VCF for ``rs34100645``

While there are more than 1000 SNPs in our vcf file, we only need one for today's exercise.  So let's go ahead and subset the VCF for that SNP.


```bash
$ vcftools --vcf human_chr2.vcf --snp rs34100645 --recode --out lactose


VCFtools - 0.1.15
(C) Adam Auton and Anthony Marcketta 2009

Parameters as interpreted:
	--vcf human_chr2.vcf
	--out lactose
	--recode
	--snp rs34100645

After filtering, kept 2504 out of 2504 Individuals
Outputting VCF file...
After filtering, kept 1 out of a possible 1248 Sites
Run Time = 0.00 seconds

```

In the above command, we extracted data for SNP rs34100645 from the file human_chr2.vcf and provided a prefix ``lactose`` for the output file. Check the output:

```bash

$ ls -l

-rw-rw-r-- 1 [inbreNNN] inbre-train 12572407 Nov 12 16:19 human_chr2.vcf
-rw-rw-r-- 1 [inbreNNN] inbre-train      306 Nov 12 16:21 lactose.log
-rw-rw-r-- 1 [inbreNNN] inbre-train    30135 Nov 12 16:21 lactose.recode.vcf

```

The information that was printed to the screen was also populated inside the log file ``lactose.log``. Your main output file is ``lactose.recode.vcf``, but let's change its name to ``lactose.vcf`` for convenience.

```bash


$ mv lactose.recode.vcf lactose.vcf

$ ls -l

-rw-rw-r-- 1 [inbreNNN] inbre-train    30135 Nov 12 16:21 lactose.vcf

```

<a name="freq"></a>


## 3. Gene Frequency

As we discussed earlier, allele frequency is a measure of the relative proportion of the two forms of a gene in a population. If a given SNP is not polymorphic, it will have only one form. Frequency of that form will be ``f = 1.00`` or 100%. However, if it is polymorphic, the resulting gene forms (alleles) may either be present at equal proportion (``f(p) = f(q) = 0.5``) or at variable proportions such as ``f(p) = 0.25`` and ``f(q) = 0.75``. No matter their relative proportion, the frequencies of the two alleles will always add up to 1 in any population sample.


### 3.1 Frequency of ``rs34100645`` Alleles

We can use VCFTools to quickly estimate frequencies of the two alleles (``A/T``). But remember that allele frequency is a measure of population(s). During today's exercise, we want to calculate these frequencies in each of the 26 human populations that we have data for. However, the vcf files does not contain any information on which individuals belong to which populations.  Instead the population classification information is present in the folder ``popfiles``:


```bash

$ ls -l popfiles/
total 0

-rw-rw-r-- 1 [inbreNNN] inbre-train 768 Nov 12 16:31 ACB.pop
-rw-rw-r-- 1 [inbreNNN] inbre-train 488 Nov 12 16:31 ASW.pop
-rw-rw-r-- 1 [inbreNNN] inbre-train 688 Nov 12 16:31 BEB.pop
-rw-rw-r-- 1 [inbreNNN] inbre-train 744 Nov 12 16:31 CDX.pop
-rw-rw-r-- 1 [inbreNNN] inbre-train 792 Nov 12 16:31 CEU.pop
-rw-rw-r-- 1 [inbreNNN] inbre-train 824 Nov 12 16:31 CHB.pop
-rw-rw-r-- 1 [inbreNNN] inbre-train 840 Nov 12 16:31 CHS.pop
-rw-rw-r-- 1 [inbreNNN] inbre-train 752 Nov 12 16:31 CLM.pop
-rw-rw-r-- 1 [inbreNNN] inbre-train 792 Nov 12 16:31 ESN.pop
-rw-rw-r-- 1 [inbreNNN] inbre-train 792 Nov 12 16:31 FIN.pop
-rw-rw-r-- 1 [inbreNNN] inbre-train 728 Nov 12 16:31 GBR.pop
-rw-rw-r-- 1 [inbreNNN] inbre-train 824 Nov 12 16:31 GIH.pop
-rw-rw-r-- 1 [inbreNNN] inbre-train 904 Nov 12 16:31 GWD.pop
-rw-rw-r-- 1 [inbreNNN] inbre-train 856 Nov 12 16:31 IBS.pop
-rw-rw-r-- 1 [inbreNNN] inbre-train 816 Nov 12 16:31 ITU.pop
-rw-rw-r-- 1 [inbreNNN] inbre-train 832 Nov 12 16:31 JPT.pop
-rw-rw-r-- 1 [inbreNNN] inbre-train 792 Nov 12 16:31 KHV.pop
-rw-rw-r-- 1 [inbreNNN] inbre-train 792 Nov 12 16:31 LWK.pop
-rw-rw-r-- 1 [inbreNNN] inbre-train 680 Nov 12 16:31 MSL.pop
-rw-rw-r-- 1 [inbreNNN] inbre-train 512 Nov 12 16:31 MXL.pop
-rw-rw-r-- 1 [inbreNNN] inbre-train 680 Nov 12 16:31 PEL.pop
-rw-rw-r-- 1 [inbreNNN] inbre-train 768 Nov 12 16:31 PJL.pop
-rw-rw-r-- 1 [inbreNNN] inbre-train 832 Nov 12 16:31 PUR.pop
-rw-rw-r-- 1 [inbreNNN] inbre-train 816 Nov 12 16:31 STU.pop
-rw-rw-r-- 1 [inbreNNN] inbre-train 856 Nov 12 16:31 TSI.pop
-rw-rw-r-- 1 [inbreNNN] inbre-train 864 Nov 12 16:31 YRI.pop


```


Each of these popfiles contains a list of individuals that belong to that specific population. Try using the linux command ``cat`` on some of the files to see what is inside. Next, we will be writing a simple shell script to automate the estimation of allele frequencies using these population files and VCFTools. This script consumes very little computational resources, so we will not run it using sbatch. Thus you can exclude the scheduler commands that begin with #SBATCH for this script.



```bash


$ vim makefreq.sh

   #!/bin/bash

   ## Make folder to store frequency output
   mkdir freq

   ## Navigate to the folder ‘popfiles/’
   cd popfiles/

   ## For loop
   for p in *.pop
   do
     vcftools --vcf ../lactose.vcf --keep $p --freq --out ../freq/$p
   done
   cd ..


```

Save and close the file.  This script demonstrates a simple for loop which iterates over popfiles shown above and executes vcftools (to estimate allele frequencies) for only the individuals in the population file currently under iteration. Go ahead and execute it. Then look at the results.
  

```bash

$ bash makefreq.sh

$ pwd
/project/inbre-train/[inbreNNN]/LASTNAME_Week5

$ cd freq

$ ls -l

-rw-rw-r-- 1 [inbreNNN] inbre-train 37111 Nov 12 16:48 ACB.pop.frq
-rw-rw-r-- 1 [inbreNNN] inbre-train 50000 Nov 12 16:48 ACB.pop.log

-rw-rw-r-- 1 [inbreNNN] inbre-train 36716 Nov 12 16:48 ASW.pop.frq
-rw-rw-r-- 1 [inbreNNN] inbre-train 50000 Nov 12 16:48 ASW.pop.log

-rw-rw-r-- 1 [inbreNNN] inbre-train 36201 Nov 12 16:48 BEB.pop.frq
-rw-rw-r-- 1 [inbreNNN] inbre-train 50000 Nov 12 16:48 BEB.pop.log

-rw-rw-r-- 1 [inbreNNN] inbre-train 35319 Nov 12 16:48 CDX.pop.frq
-rw-rw-r-- 1 [inbreNNN] inbre-train 50000 Nov 12 16:48 CDX.pop.log

-rw-rw-r-- 1 [inbreNNN] inbre-train 35082 Nov 12 16:48 CEU.pop.frq
-rw-rw-r-- 1 [inbreNNN] inbre-train 50000 Nov 12 16:48 CEU.pop.log


```

Above, we have truncated the output of the ls command after the first four lines. You should be seeing 52 files altogether, of which half are freq files and the other half are log files from VCFTools. Let's look inside one of the population allele frequency files.


```bash

$ cat ACB.pop.frq 

CHROM	POS		N_ALLELES	N_CHR	{ALLELE:FREQ}
2	135805941		2	192	A:0.6875	T:0.3125

```

The output is self explanatory. The SNP we are studying (rs34100645) is located on Chromosome 2 at base position 135805941. Being polymorphic, it has two forms (alleles). In population ACB, there are 192 chromosomes altogether (2 per individual @ 96 individuals). Finally, frequencies of both alleles are provided. Notice that the frequencies add up to 1.0 as per expectation.

In order to visualize these allele frequencies for all 26 populations, we first need to combine information from all 26 output files. Simplest way would be to use ``cat`` command.

```bash

$ cat *.frq > all.freq

$ head -n 6 all.freq

CHROM	POS	N_ALLELES	N_CHR	{ALLELE:FREQ}
2	135805941	2	192	A:0.6875	T:0.3125
CHROM	POS	N_ALLELES	N_CHR	{ALLELE:FREQ}
2	135805941	2	122	A:0.688525	T:0.311475
CHROM	POS	N_ALLELES	N_CHR	{ALLELE:FREQ}
2	135805941	2	172	A:0.639535	T:0.360465


```

#### 3.2 Formatting the ``all.freq`` File

For our downstream visualization analysis, we need to get this file into correct format. You may have noticed that each allele frequency estimate has a header line. We do not need this redundant information for downstream analysis. Only one instance of the header line should be su cient. We can selectively extract only those lines that we care about from this file. Let's grab these lines.

```bash

$ sed -n '1p;0~2p' all.freq > master.freq

$ head master.freq

CHROM	POS	N_ALLELES	N_CHR	{ALLELE:FREQ}
2	135805941	2	192	A:0.6875	T:0.3125
2	135805941	2	122	A:0.688525	T:0.311475
2	135805941	2	172	A:0.639535	T:0.360465
2	135805941	2	186	A:0.580645	T:0.419355
2	135805941	2	198	A:0.914141	T:0.0858586
2	135805941	2	206	A:0.762136	T:0.237864
2	135805941	2	210	A:0.719048	T:0.280952
2	135805941	2	188	A:0.765957	T:0.234043
2	135805941	2	198	A:0.631313	T:0.368687


```

The sed command above extracts line 1 (i.e. the first header line), and then every 2nd line from ``all.freq`` and outputs them to a new file ``master.freq``. The output contains 27 lines (header + 1 line per population). We do not have population names in this file, but their order is alphabetical. So we should still be able to discern what frequency belongs to which population during the analysis.  We need to make two more changes to ``master.freq``. Both require opening it in ``vim``.


1. This file has 6 columns, but the column header has only 5 names. Delete the string ``{ALLELE:FREQ}`` and replace it with ``Allele_A`` ``TAB`` ``Allele_T``. You will need to open the file in vim and then activate ``INSERT`` mode to make this change, i.e. press ``i``

2. Delete the allele names ``A:`` and ``T:`` as follows. This should be done using the ``COMMAND`` mode, i.e. press ``ESC``.

```bash

$ vim master.freq

:%s/A://g
:%s/T://g
:wq

```

After saving and closing the file make sure it looks as expected:

```bash

$ head master.freq

CHROM	POS	N_ALLELES	N_CHR	Allele_A	Allele_T
2	135805941	2	192	0.6875		0.3125
2	135805941	2	122	0.688525	0.311475
2	135805941	2	172	0.639535	0.360465
2	135805941	2	186	0.580645	0.419355
2	135805941	2	198	0.914141	0.0858586
2	135805941	2	206	0.762136	0.237864
2	135805941	2	210	0.719048	0.280952
2	135805941	2	188	0.765957	0.234043
2	135805941	2	198	0.631313	0.368687

```


#### 3.3 The ``popdata`` File


At the base of today's working directory (``/project/inbre-train/Week5Data/``), there is a file named ``popdata``. It contains alphabetical list of population names whose lines correspond to those in allele frequency file. Check to make sure the file exists. This file also contains information on geographical locations of each of the 26 human populations we are studying. The populations are in turn grouped into 5 super populations.


```bash
$ pwd

/project/inbre-train/[inbreNNN]/Week5/freq

$ ls -l ../podata

-rw-rw-r-- 1 [inbreNNN] inbre-train 1089 Nov 12 17:24 popdata


```


#### 3.4 Join ``popdata`` with ``master.freq``

The simplest way to accomplish this is using ``paste`` utility.

```bash

$ paste ../popdata master.freq > freq.df

$ head freq.df

pop     dist    superpop        lat     long    popname	CHROM	POS	N_ALLELES	N_CHR	Allele_A	Allele_T
ACB     13.19   AFR     13.1776 -59.5412        African_Carib_BBDS	2	135805941	2	192	0.6875	0.3125
ASW     -8.78   AFR     36.1070 -112.1130       African_Ancestry_SW_USA	2	135805941	2	122	0.688525	0.311475
BEB     23.68   SAS     23.6850 90.3563 Bengali_in_Bangladesh	2	135805941	2	172	0.639535	0.360465
CDX     22.01   EAS     22.0088 -100.7971       Chinese_Dai	2	135805941	2	186	0.580645	0.419355
CEU     62.28   EUR     39.3210 -111.0937       Utah_Resid_from_NWEurope	2	135805941	2	198	0.914141	0.0858586
CHB     23.13   EAS     39.9042 116.4074        Han_Chinese	2	135805941	2	206	0.762136	0.237864
CHS     24.48   EAS     23.9790 113.7633        Southern_Han_Chinese	2	135805941	2	210	0.719048	0.280952
CLM     6.24    AMR     6.2442  -75.5812        Columbian_Medellin	2	135805941	2	188	0.765957	0.234043
ESN     10.22   AFR     9.0820  8.6753  Esan_in_Nigeria	2	135805941	2	198	0.631313	0.368687


```



#### 3.5 Download the ``freq.df`` File to Workstation

Recall that in order to copy files from server to local workstation, you will first need to open a new terminal window (``Cmd+Tab``).

```bash

$ cd ~/

$ mkdir LASTNAME_week5

$ cd LASTNAME_week5/

$ scp [inbreNNN]@mtmoran.uwyo.edu:/project/inbre-train/[inbreNNN]/Week5/freq.df .


```




























