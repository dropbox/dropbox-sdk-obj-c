#!/bin/sh
cd Source/ObjectiveDropboxOfficial/include
#equivalent to:   s.public_header_files = 'Source/ObjectiveDropboxOfficial/Shared/**/*.h'
find ../Shared -name "*.h" | sort | uniq | while read header; do
	ln -s ${header}
done
#equivalent to:  s.public_header_files = 'Source/ObjectiveDropboxOfficial/Headers/Umbrella/*.h'
find ../Headers/Umbrella -name "*.h" | sort | uniq | while read header; do
		ln -s ${header}
done
#equivalent to: s.osx.public_header_files = 'Source/ObjectiveDropboxOfficial/Platform/ObjectiveDropboxOfficial_macOS/**/*.h'
find ../Platform/ObjectiveDropboxOfficial_macOS -name "*.h" | sort | uniq | while read header; do
		ln -s ${header}
done
#equivalent to: s.ios.public_header_files = 'Source/ObjectiveDropboxOfficial/Platform/ObjectiveDropboxOfficial_iOS/**/*.h'
find ../Platform/ObjectiveDropboxOfficial_iOS -name "*.h" | sort | uniq | while read header; do
		ln -s ${header}
done
