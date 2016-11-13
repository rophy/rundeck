#!/bin/bash

#test output from /api/execution/{id}
# test 404 response

DIR=$(cd `dirname $0` && pwd)
source $DIR/include.sh

execid="000"

test_execution_notfound_xml(){

	####
	# Test: request with 404 response
	####


	ENDPOINT="$APIURL/execution/$execid"
	ACCEPT=application/xml
	EXPECT_STATUS=404

	test_begin "GET execution not found (xml)"

	api_request $ENDPOINT $DIR/curl.out

	assert_xml_valid $DIR/curl.out

	test_succeed

}

test_execution_notfound_json(){

	ENDPOINT="$APIURL/execution/$execid"
	ACCEPT=application/json
	EXPECT_STATUS=404

	test_begin "GET execution not found (json)"

	api_request $ENDPOINT $DIR/curl.out

	assert_json_value "api.error.item.doesnotexist" ".errorCode" $DIR/curl.out

	test_succeed
}

main(){
	test_execution_notfound_xml
	test_execution_notfound_json
}
main