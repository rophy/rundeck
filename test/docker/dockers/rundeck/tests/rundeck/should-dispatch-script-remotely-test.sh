#!/usr/bin/env roundup
#

: ${RUNDECK_USER?"environment variable not set."} 
: ${RUNDECK_PROJECT?"environment variable not set."}
: ${REMOTE_NODE?"environment variable not set."}

# Let's get started
# -----------------

# Helpers
# ------------

#. ./include.sh 


# The Plan
# --------
describe "project: dispatch script remote node"

it_should_dispatch_script_remotely() {
    # Run the script file on the remote node
    bash -c "rd adhoc -p $RUNDECK_PROJECT -f -F $REMOTE_NODE -s /tests/rundeck/test-dispatch-script.sh | grep -v ^#" > test.output
    
    # diff with expected
    cat >expected.output <<END
This is test-dispatch-script.sh
On node $REMOTE_NODE $REMOTE_NODE
With tags: remote remote
With args: 
END
    set +e
    diff expected.output test.output
    result=$?
    set -e
    rm expected.output test.output #test2.output
    if [ 0 != $result ] ; then
        echo "FAIL: output differed from expected"
        exit 1
    fi
}

it_should_dispatch_script_utf8_remotely() {
    # Run the script file on the remote node
    bash -c "RD_DEBUG=3 rd adhoc -p $RUNDECK_PROJECT -f -F $REMOTE_NODE -s /tests/rundeck/test-dispatch-script-utf8.sh | grep -v ^#" > test2.output

    bash -c "rd adhoc -p $RUNDECK_PROJECT -f -F $REMOTE_NODE -s /tests/rundeck/test-dispatch-script-utf8.sh | grep -v ^#" > test.output
    
    # diff with expected
    cat >expected.output <<END
This is test-dispatch-script-utf8.sh
UTF-8 Text: 你好
END
    set +e
    diff expected.output test.output
    result=$?
    set -e
    rm expected.output test.output #test2.output
    if [ 0 != $result ] ; then
        echo "FAIL: output differed from expected"
        cat test2.output
        exit 1
    fi
}

it_should_dispatch_script_remotely_dos_lineendings() {
    # Run the script file on the remote node
    bash -c "rd adhoc -p $RUNDECK_PROJECT -f -F $REMOTE_NODE -s /tests/rundeck/test-dispatch-script-dos.sh | grep -v ^#" > test.output
    
    # diff with expected
    cat >expected.output <<END
This is test-dispatch-script-dos.sh
On node $REMOTE_NODE $REMOTE_NODE
With tags: remote remote
With args: 
END
    set +e
    diff expected.output test.output
    result=$?
    set -e
    rm expected.output test.output #test2.output
    if [ 0 != $result ] ; then
        echo "FAIL: output differed from expected"
        exit 1
    fi
}

it_should_dispatch_script_remotely_with_args() {
    bash -c "rd adhoc -p $RUNDECK_PROJECT -f -F '$REMOTE_NODE' -s /tests/rundeck/test-dispatch-script.sh -- arg1 arg2 | grep -v ^#"> test.output
    
    # diff with expected
    cat >expected.output <<END
This is test-dispatch-script.sh
On node $REMOTE_NODE $REMOTE_NODE
With tags: remote remote
With args: arg1 arg2
END
    set +e
    diff expected.output test.output
    result=$?
    set -e
    rm expected.output test.output #test2.output
    if [ 0 != $result ] ; then
        echo "FAIL: output differed from expected"
        exit 1
    fi
}

it_should_dispatch_url_remotely() {
    bash -c "rd adhoc -p $RUNDECK_PROJECT -f -F '$REMOTE_NODE' -u file:/tests/rundeck/test-dispatch-script.sh -- arg1 arg2 | grep -v ^#"> test.output
    
    # diff with expected
    cat >expected.output <<END
This is test-dispatch-script.sh
On node @node.name@ $REMOTE_NODE
With tags: @node.tags@ remote
With args: arg1 arg2
END
    set +e
    diff expected.output test.output
    result=$?
    set -e
    rm expected.output test.output #test2.output
    if [ 0 != $result ] ; then
        echo "FAIL: output differed from expected"
        exit 1
    fi
}

it_should_dispatch_url_utf8_remotely() {
    bash -c "rd adhoc -p $RUNDECK_PROJECT -f -F '$REMOTE_NODE' -u file:/tests/rundeck/test-dispatch-script-utf8.sh -- arg1 arg2 | grep -v ^#"> test.output
    
    # diff with expected
    cat >expected.output <<END
This is test-dispatch-script-utf8.sh
UTF-8 Text: 你好
END
    set +e
    diff expected.output test.output
    result=$?
    set -e
    rm expected.output test.output #test2.output
    if [ 0 != $result ] ; then
        echo "FAIL: output differed from expected"
        exit 1
    fi
}