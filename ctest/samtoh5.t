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
  $ rm -rf $OUTDIR/ecoli.cmp.h5
  $ $EXEC -useShortRefName $DATDIR/ecoli.sam $DATDIR/ecoli_reference.fasta $OUTDIR/ecoli.cmp.h5
  $ h5diff $OUTDIR/ecoli.cmp.h5 $STDDIR/ecoli.cmp.h5
  dataset: </FileLog/CommandLine> and </FileLog/CommandLine>
  \d+ differences found (re)
  dataset: </FileLog/Timestamp> and </FileLog/Timestamp>
  \d+ differences found (re)
  [1]

#Verify bug 21794 has been fixed. 
#samtoh5 should print the following error message.
  $ rm -rf $OUTDIR/bug21794.cmp.h5
  $ $EXEC $DATDIR/bug21794.sam $DATDIR/bug21794_reference.fasta $OUTDIR/bug21794.cmp.h5
  WARNING. The mapping of read m120504_033026_sherri_c100311672550000001523012508061292_s1_p0/71092/3721_4845 to reference chr4_ctg9_hap1 is out of bounds.
           StartPos (4294967288) + AlnLength (614) > RefLength (590426) + 2 


#Test boundary case where a read exactly maps to the end of reference. 
  $ rm -rf $OUTDIR/bad.cmp.h5
  $ $EXEC -useShortRefName $DATDIR/bad.sam $DATDIR/ecoli_mutated.fasta $OUTDIR/bad.cmp.h5
  $ h5diff $OUTDIR/bad.cmp.h5 $STDDIR/bad.cmp.h5
  dataset: </FileLog/CommandLine> and </FileLog/CommandLine>
  \d+ differences found (re)
  dataset: </FileLog/Timestamp> and </FileLog/Timestamp>
  \d+ differences found (re)
  [1]

#Test more out-of-boundary cases. samtoh5 prints warnings.
  $ rm -rf $OUTDIR/bad2.cmp.h5
  $ $EXEC $DATDIR/bad2.sam $DATDIR/ecoli_mutated.fasta $OUTDIR/bad2.cmp.h5
  WARNING. The mapping of read m120724_232507_ethan_c100384812550000001523033110171290_s1_p0/21020/11218_12655 to reference ecoliK12_mutated is out of bounds.
           StartPos (4638237) + AlnLength (1327) > RefLength (4639560) + 2 
  WARNING. The mapping of read m120724_232507_ethan_c100384812550000001523033110171290_s1_p0/60189/0_4202 to reference ecoliK12_mutated is out of bounds.
           StartPos (4639141) + AlnLength (431) > RefLength (4639560) + 2 

#Test samtoh5 uses full reference names instead of short reference names, if -useShortRefName is not specified 
  $ rm -rf $OUTDIR/ecoli_fullRefName.cmp.h5
  $ $EXEC $DATDIR/ecoli.sam $DATDIR/ecoli_reference.fasta $OUTDIR/ecoli_fullRefName.cmp.h5
  $ h5diff $OUTDIR/ecoli_fullRefName.cmp.h5 $STDDIR/ecoli_fullRefName.cmp.h5
  dataset: </FileLog/CommandLine> and </FileLog/CommandLine>
  \d+ differences found (re)
  dataset: </FileLog/Timestamp> and </FileLog/Timestamp>
  \d+ differences found (re)
  [1]

  $ h5dump --dataset /RefInfo/FullName $OUTDIR/ecoli_fullRefName.cmp.h5 | sed -n '11p'
     (0): "ref000001|gi|49175990|ref|NC_000913.2| Escherichia coli str. K-12 substr. MG1655 chromosome, complete genome"

#Compare the generated reference names with option -useShortRefName is set
  $ h5dump --dataset /RefInfo/FullName $OUTDIR/ecoli.cmp.h5 |sed -n '11p'
     (0): "ref000001|gi|49175990|ref|NC_000913.2|"

#Test whether samtoh5 generates correct MD5 for the output cmp.h5 files
#even if there are invalid MD5 values in the input sam file.  bug 22578.
  $ rm -rf $OUTDIR/test_MD5.cmp.h5
  $ $EXEC $DATDIR/test_MD5.sam $DATDIR/test_MD5MultiContigsRef.fasta $OUTDIR/test_MD5.cmp.h5
  $ h5dump -d /RefInfo/MD5 $OUTDIR/test_MD5.cmp.h5 |tail -7 |head -4 
     (0): "3cba630ed67592e8e11fb94ef99a122a",
     (1): "a687c808a666ea90e0a273c4ac2591c3",
     (2): "81cf96e23ab1392d898a697c9c4c3acd",
     (3): "4f4bff70a6ac5ae926e5ed6165684dd3"
