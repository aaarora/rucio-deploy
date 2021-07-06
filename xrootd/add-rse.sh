XRDHOSTNAME=''
RSE=''
rucio-admin rse add $RSE
rucio-admin rse add-protocol --hostname $XRDHOSTNAME --scheme http --prefix / --port 1094 --impl rucio.rse.protocols.webdav.Default --domain-json '{"wan": {"read": 1, "write": 1, "delete": 1, "third_party_copy": 1}, "lan": {"read": 1, "write": 1, "delete": 1}}' $RSE
rucio-admin rse set-attribute --rse $RSE --key test_container_xrd --value True
rucio-admin rse set-attribute --rse $RSE --key fts --value https://fts:8446
rucio-admin account set-limits root $RSE -1
rucio -vvv upload --rse $RSE --scope test file1
