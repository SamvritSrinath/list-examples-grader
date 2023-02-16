CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
git clone $1 student-submission
echo 'Finished cloning'
STUDENTFILE='student-submission/ListExamples.java'

if [[ -f $STUDENTFILE ]]
	then
		echo "File Exists"
	else 
		echo "The student code was not provided"
		exit 1
fi 


cp student-submission/ListExamples.java .

javac -cp $CPATH *.java 2> compErrors.txt 
if [[ -s compErrors.txt ]]
	then
		echo "Compilation Error, tests will not execute"
		exit 1
	else
		echo "Compilation Successful"
fi
java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > errors.txt
cat errors.txt
TESTLINE=`grep "Failures" errors.txt`
if [[ -z TESTLINE ]]
	then
		echo "Your grade was 100%"
		exit 0
fi
echo $TESTLINE
TESTS=${TESTLINE:11:1}
FAILURES=${TESTLINE:25:1}
GRADE=$((100 * (FAILURES) / (TESTS + FAILURES)))
# echo $GRADE
echo "You have $FAILURES failures out of $TESTS tests, your grade is $GRADE%"