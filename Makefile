
DEVELOPER_KEY='/Users/robertbuessow/StudioProjects/developer_key'
device ?= fenix7
opt ?= 2

shared_dep = Shared/source/*.mc Shared/resource/*/*

%/resources/_version.xml: %/manifest.xml
	v=`xmlstarlet select --text --template --value-of '//iq:manifest/iq:application/@version' -n $<`; \
	echo "<strings><string id='Version'>$$v</string><string id='BuildTime'>`date -Iminutes`</string></strings>" > "$@"

bin-$(device)/%.prg: %/monkey.jungle %/manifest.xml %/source/*.mc %/resources/_version.xml %/resources*/* $(shared_dep)
	[ -d "$(@D)" ] || mkdir "$(@D)"
	monkeyc --jungle $< --output $@ --private-key $(DEVELOPER_KEY) --warn --optimization $(opt) --device $(device) $(test_flag)

bin/%.iq: %/monkey.jungle %/manifest.xml %/source/*.mc %/resources/_version.xml %/resources*/* $(shared_dep)
	[ -d "$(@D)" ] || mkdir "$(@D)"
	monkeyc --jungle $< --output $@ --private-key $(DEVELOPER_KEY) --warn --optimization 3pz --package-app --release

GlucoseDataField: bin-$(device)/GlucoseDataField.prg
GlucoseWidget: bin-$(device)/GlucoseWidget.prg
GlucoseWatchFace: bin-$(device)/GlucoseWatchFace.prg

.PHONY: test
test: test_flag = --unit-test
test: bin-$(device)/Test.prg
	connectiq $(device)
	sleep 2
	monkeydo bin-$(device)/Test.prg $(device) -t
	killall simulator

.PHONY: %/run
%/run: %
	connectiq $(device)
	sleep 2
	monkeydo bin-$(device)/$(@D).prg $(device) 
	killall simulator

.PHONY: clean
clean:
	rm -rf bin-*
	rm */resources/_version.xml