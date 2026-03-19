#!/usr/bin/ksh


echo {01..10%02d}
print {01..10%02d}
# 01 02 03 04 05 06 07 08 09 10

# output len 2 chars
echo {7..18%02x}
# 07 08 09 0a 0b 0c 0d 0e 0f 10 11 12

# output len 4 chars
echo {7..18%04x}
# 0007 0008 0009 000a 000b 000c 000d 000e 000f 0010 0011 0012


# 10 to 99
for i in {10..99%02d}
do
	echo $i
done
