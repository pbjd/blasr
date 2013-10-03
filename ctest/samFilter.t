For testing samFilter
Set up directories
  $ CURDIR=$TESTDIR
  $ REMOTEDIR=/mnt/secondary-siv/secondarytest/testdata/BlasrTestData/ctest
  $ DATDIR=$REMOTEDIR/data
  $ OUTDIR=$CURDIR/out
  $ STDDIR=$REMOTEDIR/stdout

Set up the executable: samFilter.
  $ BIN=$TESTDIR/../pbihdfutils/bin/
  $ EXEC=$BIN/samFilter

#Test samFilter with a *.sam file generated by blasr
  $ OUTFILE=$OUTDIR/lambda_bax_filter_1.sam
  $ STDFILE=$STDDIR/lambda_bax_filter_1.sam
  $ TMP1=$OUTDIR/$$.tmp.out 
  $ TMP2=$OUTDIR/$$.tmp.stdout 

  $ rm -f $OUTFILE
  $ $EXEC $DATDIR/lambda_bax.sam $DATDIR/lambda_ref.fasta $OUTFILE -minAccuracy 70 -minPctSimilarity 30 -hitPolicy all
  $ tail -n+7 $OUTFILE > $TMP1 
  $ tail -n+7 $STDFILE > $TMP2 
  $ diff $TMP1 $TMP2 
  $ rm $TMP1 $TMP2 

#Test samFilter with -hitPolicy allbest
  $ OUTFILE=$OUTDIR/lambda_bax_filter_2.sam
  $ STDFILE=$STDDIR/lambda_bax_filter_2.sam

  $ rm -f $OUTFILE
  $ $EXEC $DATDIR/lambda_bax.sam $DATDIR/lambda_ref.fasta $OUTFILE -hitPolicy allbest
  $ tail -n+7 $OUTFILE > $TMP1 
  $ tail -n+7 $STDFILE > $TMP2 
  $ diff $TMP1 $TMP2 
  $ rm $TMP1 $TMP2 

#Test samFilter with -hitPolicy random   
  $ OUTFILE=$OUTDIR/lambda_bax_filter_3.sam
  $ STDFILE=$STDDIR/lambda_bax_filter_3.sam

  $ rm -f $OUTFILE
  $ $EXEC $DATDIR/lambda_bax.sam $DATDIR/lambda_ref.fasta $OUTFILE -hitPolicy random
  $ tail -n+7 $OUTFILE > $TMP1 
  $ tail -n+7 $STDFILE > $TMP2 
  $ diff $TMP1 $TMP2 
  $ rm $TMP1 $TMP2 

#Test samFilter with -hitPolicy randombest   
  $ OUTFILE=$OUTDIR/lambda_bax_filter_4.sam
  $ STDFILE=$STDDIR/lambda_bax_filter_4.sam

  $ rm -f $OUTFILE
  $ $EXEC $DATDIR/lambda_bax.sam $DATDIR/lambda_ref.fasta $OUTFILE -hitPolicy randombest 
  $ tail -n+7 $OUTFILE > $TMP1 
  $ tail -n+7 $STDFILE > $TMP2 
  $ diff $TMP1 $TMP2 
  $ rm $TMP1 $TMP2 


#Test samFilter with -scoreFunction 
  $ OUTFILE=$OUTDIR/lambda_bax_filter_5.sam
  $ STDFILE=$STDDIR/lambda_bax_filter_5.sam

  $ rm -f $OUTFILE
  $ $EXEC $DATDIR/lambda_bax.sam $DATDIR/lambda_ref.fasta $OUTFILE -scoreFunction alignerscore
  $ tail -n+7 $OUTFILE > $TMP1 
  $ tail -n+7 $STDFILE > $TMP2 
  $ diff $TMP1 $TMP2 
  $ rm $TMP1 $TMP2 

#Test samFilter with -holeNumbers
  $ OUTFILE=$OUTDIR/lambda_bax_filter_6.sam
  $ STDFILE=$STDDIR/lambda_bax_filter_6.sam

  $ rm -f $OUTFILE
  $ $EXEC $DATDIR/lambda_bax.sam $DATDIR/lambda_ref.fasta $OUTFILE -holeNumbers 101350-105000,21494 
  $ tail -n+7 $OUTFILE > $TMP1 
  $ tail -n+7 $STDFILE > $TMP2 
  $ diff $TMP1 $TMP2 
  $ rm $TMP1 $TMP2 
