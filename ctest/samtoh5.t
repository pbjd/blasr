Set up directories
  $ CURDIR=$TESTDIR
  $ REMOTEDIR=/mnt/secondary-siv/secondarytest/testdata/BlasrTestData/ctest
  $ DATDIR=$REMOTEDIR/data
  $ OUTDIR=$CURDIR/out
  $ STDDIR=$REMOTEDIR/stdout

Set up the executable: samtoh5.
  $ BIN=$TESTDIR/../pbihdfutils/bin/
  $ EXEC=$BIN/samtoh5

#Test samtoh5 with *.sam files generated by blasr.
  $ rm -f $OUTDIR/ecoli.cmp.h5
  $ $EXEC -useShortRefName $DATDIR/ecoli.sam $DATDIR/ecoli_reference.fasta $OUTDIR/ecoli.cmp.h5
  [INFO] * [samtoh5] started. (glob)
  [INFO] * [samtoh5] ended. (glob)
  $ h5diff $OUTDIR/ecoli.cmp.h5 $STDDIR/ecoli.cmp.h5
  dataset: </FileLog/CommandLine> and </FileLog/CommandLine>
  \d+ differences found (re)
  dataset: </FileLog/Timestamp> and </FileLog/Timestamp>
  \d+ differences found (re)
  dataset: </FileLog/Version> and </FileLog/Version>
  \d+ differences found (re)
  [1]

#Verify bug 21794 has been fixed. 
#samtoh5 should print the following error message.
  $ rm -f $OUTDIR/bug21794.cmp.h5
  $ $EXEC $DATDIR/bug21794.sam $DATDIR/bug21794_reference.fasta $OUTDIR/bug21794.cmp.h5
  [INFO] * [samtoh5] started. (glob)
  WARNING. The mapping of read m120504_033026_sherri_c100311672550000001523012508061292_s1_p0/71092/3721_4845 to reference chr4_ctg9_hap1 is out of bounds.
           StartPos (4294967288) + AlnLength (614) > RefLength (590426) + 2 
  [INFO] * [samtoh5] ended. (glob)


#Test boundary case where a read exactly maps to the end of reference. 
  $ rm -f $OUTDIR/bad.cmp.h5
  $ $EXEC -useShortRefName $DATDIR/bad.sam $DATDIR/ecoli_mutated.fasta $OUTDIR/bad.cmp.h5
  [INFO] * [samtoh5] started. (glob)
  [INFO] * [samtoh5] ended. (glob)

  $ h5diff $OUTDIR/bad.cmp.h5 $STDDIR/bad.cmp.h5
  dataset: </FileLog/CommandLine> and </FileLog/CommandLine>
  \d+ differences found (re)
  dataset: </FileLog/Timestamp> and </FileLog/Timestamp>
  \d+ differences found (re)
  dataset: </FileLog/Version> and </FileLog/Version>
  \d+ differences found (re)
  [1]

#Test more out-of-boundary cases. samtoh5 prints warnings.
  $ rm -f $OUTDIR/bad2.cmp.h5
  $ $EXEC $DATDIR/bad2.sam $DATDIR/ecoli_mutated.fasta $OUTDIR/bad2.cmp.h5
  [INFO] * [samtoh5] started. (glob)
  WARNING. The mapping of read m120724_232507_ethan_c100384812550000001523033110171290_s1_p0/21020/11218_12655 to reference ecoliK12_mutated is out of bounds.
           StartPos (4638237) + AlnLength (1327) > RefLength (4639560) + 2 
  WARNING. The mapping of read m120724_232507_ethan_c100384812550000001523033110171290_s1_p0/60189/0_4202 to reference ecoliK12_mutated is out of bounds.
           StartPos (4639141) + AlnLength (431) > RefLength (4639560) + 2 
  [INFO] * [samtoh5] ended. (glob)

#Test samtoh5 uses full reference names instead of short reference names, if -useShortRefName is not specified 
  $ rm -f $OUTDIR/ecoli_fullRefName.cmp.h5
  $ $EXEC $DATDIR/ecoli.sam $DATDIR/ecoli_reference.fasta $OUTDIR/ecoli_fullRefName.cmp.h5
  [INFO] * [samtoh5] started. (glob)
  [INFO] * [samtoh5] ended. (glob)
  $ h5diff $OUTDIR/ecoli_fullRefName.cmp.h5 $STDDIR/ecoli_fullRefName.cmp.h5
  dataset: </FileLog/CommandLine> and </FileLog/CommandLine>
  \d+ differences found (re)
  dataset: </FileLog/Timestamp> and </FileLog/Timestamp>
  \d+ differences found (re)
  dataset: </FileLog/Version> and </FileLog/Version>
  \d+ differences found (re)
  [1]

  $ h5dump --dataset /RefInfo/FullName $OUTDIR/ecoli_fullRefName.cmp.h5 | sed -n '11p'
     (0): "ref000001|gi|49175990|ref|NC_000913.2| Escherichia coli str. K-12 substr. MG1655 chromosome, complete genome"

#Compare the generated reference names with option -useShortRefName is set
  $ h5dump --dataset /RefInfo/FullName $OUTDIR/ecoli.cmp.h5 |sed -n '11p'
     (0): "ref000001|gi|49175990|ref|NC_000913.2|"

#Test whether samtoh5 generates correct MD5 for the output cmp.h5 files
#even if there are invalid MD5 values in the input sam file.  bug 22578.
  $ rm -f $OUTDIR/test_MD5.cmp.h5
  $ $EXEC $DATDIR/test_MD5.sam $DATDIR/test_MD5MultiContigsRef.fasta $OUTDIR/test_MD5.cmp.h5
  [INFO] * [samtoh5] started. (glob)
  [INFO] * [samtoh5] ended. (glob)
  $ h5dump -d /RefInfo/MD5 $OUTDIR/test_MD5.cmp.h5 |tail -7 |head -4 
     (0): "3cba630ed67592e8e11fb94ef99a122a",
     (1): "a687c808a666ea90e0a273c4ac2591c3",
     (2): "81cf96e23ab1392d898a697c9c4c3acd",
     (3): "4f4bff70a6ac5ae926e5ed6165684dd3"


#Test whether samtoh5 accepts smrtTitle movie/zmw/start_end/start2_end2
  $ rm -f $OUTDIR/test_smrtTitle.cmp.h5
  $ $EXEC $DATDIR/fns.sam $DATDIR/ecoli_reference.fasta $OUTDIR/test_smrtTitle.cmp.h5
  [INFO] * [samtoh5] started. (glob)
  [INFO] * [samtoh5] ended. (glob)
  $ h5dump -d /AlnInfo/AlnIndex $OUTDIR/test_smrtTitle.cmp.h5 | sed -n '6,25p'
     (0,0): 1, 1, 1, 1, 4407727, 4407871, 0, 6, 0, 0, 0, 18, 165, 254, 137, 3,
     (0,16): 7, 4, 0, 151, 0, 0,
     (1,0): 2, 1, 1, 1, 4407311, 4407788, 1, 6, 0, 0, 1, 109, 657, 254, 460, 4,
     (1,16): 84, 13, 152, 713, 0, 0,
     (2,0): 3, 1, 1, 1, 4407314, 4407871, 0, 6, 0, 0, 2, 5, 641, 254, 547, 2,
     (2,16): 87, 8, 714, 1358, 0, 0,
     (3,0): 4, 1, 1, 1, 4407372, 4407876, 1, 6, 0, 0, 3, 0, 586, 254, 494, 2,
     (3,16): 90, 8, 1359, 1953, 0, 0,
     (4,0): 5, 1, 1, 1, 4407316, 4407877, 0, 6, 0, 0, 4, 7, 640, 254, 545, 4,
     (4,16): 84, 12, 1954, 2599, 0, 0,
     (5,0): 6, 1, 1, 1, 4407334, 4407870, 1, 6, 0, 0, 5, 6, 632, 254, 521, 6,
     (5,16): 99, 9, 2600, 3235, 0, 0,
     (6,0): 7, 1, 1, 1, 4407310, 4407868, 0, 6, 0, 0, 6, 3, 639, 254, 542, 8,
     (6,16): 86, 8, 3236, 3880, 0, 0,
     (7,0): 8, 1, 1, 1, 4407311, 4407815, 0, 6, 0, 0, 7, 0, 601, 254, 484, 5,
     (7,16): 112, 15, 3881, 4497, 0, 0,
     (8,0): 9, 1, 1, 1, 4407319, 4407806, 1, 6, 0, 0, 8, 87, 681, 254, 473, 6,
     (8,16): 115, 8, 4498, 5100, 0, 0,
     (9,0): 10, 1, 1, 1, 4407381, 4407592, 0, 6, 0, 0, 9, 93, 345, 254, 205, 3,
     (9,16): 44, 3, 5101, 5356, 0, 0


#Test whether samtoh5 mimic the behaviour of compareSequences.py and remove
#reference groups which have no alignments to any movie.
  $ NAME=test_rm_empty_refGroup
  $ rm -f $OUTDIR/$NAME.cmp.h5
  $ $EXEC $DATDIR/$NAME.sam $DATDIR/$NAME.fasta $OUTDIR/$NAME.cmp.h5
  [INFO] * [samtoh5] started. (glob)
  [INFO] * [samtoh5] ended. (glob)
  $ h5dump -d /RefGroup/ID $OUTDIR/$NAME.cmp.h5 | sed -n '6,6p'
     (0): 1, 2

  $ h5dump -d /RefGroup/Path $OUTDIR/$NAME.cmp.h5 | sed -n '11,11p'
     (0): "/ref000003", "/ref000005"
