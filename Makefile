all:
	@echo "Did you want to run 'make test'?"

upload:
	rsync --itemize-changes gridmapper.svg sibirocobombus:campaignwiki.org/
