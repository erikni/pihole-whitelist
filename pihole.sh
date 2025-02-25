#!/bin/sh

echo "pi-hole whitelist ... "
echo

echo "# pihole-whitelist" > README.md
echo "Whitelists for pi-hole.net" >> README.md
echo "" >> README.md

echo "generate whitelist for apps ..."
echo "Apps:" >> README.md
for hostfile in `ls *.hosts`; do
	host_txt="`echo $hostfile | cut -d"." -f1`.txt"
	host_name="`echo $hostfile | cut -d"." -f1`"
	echo "- ${hostfile} -> ${host_txt}"
	echo "- [${host_name}](https://raw.githubusercontent.com/erikni/pihole-whitelist/refs/heads/main/${host_txt})" >> README.md

	# header
	echo "#" > $host_txt
	echo "# --- $host_name --" >> $host_txt
	echo "# whitelist for pi-hole.net" >> $host_txt
	echo "#" >> $host_txt

	# domains
	echo "# domains:" >> $host_txt
	for domain in `cat $hostfile | rev | cut -d"." -f1,2 | rev | sort | uniq`; do
		echo "# *.${domain}" >> $host_txt
	done;
	echo "#" >> $host_txt

	# hosts
	echo "# hosts:" >> $host_txt
	for host in `cat $hostfile | sort | uniq`; do
		echo $host >> $host_txt;
	done;

	# sort & uniq *.hosts
	cat $hostfile |sort | uniq > /tmp/$hostfile
	cp /tmp/$hostfile .
	rm /tmp/$hostfile

done;
echo "" >> README.md

echo "Other:" >> README.md
echo "- [Commonly Whitelisted Domains](https://discourse.pi-hole.net/t/commonly-whitelisted-domains/212)" >> README.md

echo "" >> README.md
echo

echo "git status ... "
git status
echo

echo "finish."
