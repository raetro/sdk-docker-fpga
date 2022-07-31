#!/usr/bin/env bash

################################################################################
# Set variables
################################################################################
TAG_NAME="${TAG_NAME:=raetro/quartus}"
GIT_TAG_NAME="${GIT_TAG_NAME:=ghcr.io/raetro/quartus}"
VERSION=
BUILD_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
INTEL_CDN=https://downloads.intel.com/akdlm/software/acdsinst
declare -a fileArray

################################################################################
# Display Help
################################################################################
usage() {
	echo "Quartus Prime Lite Container Builder."
	echo
	echo "Usage: build.sh [-v] [OPTION...]"
	echo "  -v    Quartus version to build."
	echo "        [13.0, 13.1, 17.0, 17.1, 18.1, 19.1, 20.1, 21.1]"
	echo
	echo " Main modes of operation:"
	echo "  -b    Build container using remote files."
	echo "  -p    Publish container to registry."
	echo "  -g    Publish container to GitHub registry."
	echo "  -d    Download files for local build."
	echo "  -l    Build container using local files."
	echo "  -c    Check local files integrity."
	echo "  -o    Build Base OS."
	echo
	echo " eg. build.sh -v21.1 -b"
	echo "     build.sh -vbase -o"
	echo
}

################################################################################
# Check for if command has 2 parameters
################################################################################
if [ $# -ne 2 ]; then
	usage
	exit 1
fi

################################################################################
# Main functions
################################################################################

# Check if a version was provided
checkVersion(){
	# Check Version
	if [ -z "$VERSION" ]; then
		echo "No version specified."
		exit 1
	fi
}

# Download files from Intel CDN
getfile(){
	echo "-> Downloading file from Intel CDN..."
	wget -qc --show-progress "$1" -O "$2"
	echo "Done."
}

# Build container using remote files..."
build() {
	checkVersion
	BUILD_PATH="quartus${VERSION}/remote"
	echo "Building container using remote files..."
    docker build --build-arg BUILD_VERSION="${VERSION}" --build-arg BUILD_DATE="${BUILD_DATE}" -t "${TAG_NAME}":"${VERSION}" --force-rm --compress "${BUILD_PATH}"
	echo "Done."
}

# Build container using local files.
build_local() {
	checkVersion
	BUILD_PATH="quartus${VERSION}/local"
	echo "Building container using local files..."
    docker build --build-arg BUILD_VERSION="${VERSION}" --build-arg BUILD_DATE="${BUILD_DATE}" -t "${TAG_NAME}":"${VERSION}" --force-rm --compress "${BUILD_PATH}"
	echo "Done."
}

# Build container using local files.
build_base() {
	checkVersion
	BUILD_PATH="quartus-base"
	echo "Building container using local files..."
    docker build --build-arg BUILD_VERSION="base" --build-arg BUILD_DATE="${BUILD_DATE}" -t "${TAG_NAME}:base" --force-rm --compress "${BUILD_PATH}"
	echo "Done."
}

# Check the hash of the files
check_hash() {
	checkVersion
	HASHFILE_PATH="${PWD}/quartus${VERSION}/local/files/"
	echo "Checking files integrity..."
	pushd "${HASHFILE_PATH}" > /dev/null || exit
	sha1sum -c "file.lst"
	popd  > /dev/null || exit
	echo "Done."
}

# Create a variant of the container with the specified version.
tag_variation() {
	docker tag "${1}:${VERSION}" "${1}:${2}"
	docker push "${1}:${2}"
}

# Publish Container to Registry
publish() {
	checkVersion
	echo "Publishing container..."
    docker push "${TAG_NAME}":"${VERSION}"
    if [ "${VERSION}" = "13.0" ]; then
    	tag_variation "${TAG_NAME}" "13.0sp1"
    elif [ "${VERSION}" = "13.1" ]; then
    	tag_variation "${TAG_NAME}" "mc"
    	tag_variation "${TAG_NAME}" "mc2"
    	tag_variation "${TAG_NAME}" "mcp"
    	tag_variation "${TAG_NAME}" "mist"
    	tag_variation "${TAG_NAME}" "neptuno"
    	tag_variation "${TAG_NAME}" "sidi"
    	tag_variation "${TAG_NAME}" "tc64v1"
    	tag_variation "${TAG_NAME}" "uareloaded"
    elif [ "${VERSION}" = "17.0" ]; then
    	tag_variation "${TAG_NAME}" "mister"
    elif [ "${VERSION}" = "17.1" ]; then
    	tag_variation "${TAG_NAME}" "mimic"
    	tag_variation "${TAG_NAME}" "atlas"
    elif [ "${VERSION}" = "18.1" ]; then
    	tag_variation "${TAG_NAME}" "tc64v2"
    	tag_variation "${TAG_NAME}" "pocket"
    elif [ "${VERSION}" = "21.1" ]; then
    	tag_variation "${TAG_NAME}" "21.1.1"
    fi
	echo "Done."
}

# Publish Container to GitHub Registry
publish_to_github() {
	checkVersion
	docker tag "${TAG_NAME}:${VERSION}" "${GIT_TAG_NAME}:${VERSION}"
	docker push "${GIT_TAG_NAME}:${VERSION}"
	echo "Publishing container to GitHub..."
    if [ "${VERSION}" = "13.0" ]; then
    	tag_variation "${TAG_NAME}" "13.0sp1"
    elif [ "${VERSION}" = "13.1" ]; then
    	tag_variation "${GIT_TAG_NAME}" "mc"
    	tag_variation "${GIT_TAG_NAME}" "mc2"
    	tag_variation "${GIT_TAG_NAME}" "mcp"
    	tag_variation "${GIT_TAG_NAME}" "mist"
    	tag_variation "${GIT_TAG_NAME}" "neptuno"
    	tag_variation "${GIT_TAG_NAME}" "sidi"
    	tag_variation "${GIT_TAG_NAME}" "tc64v1"
    	tag_variation "${GIT_TAG_NAME}" "uareloaded"
    elif [ "${VERSION}" = "17.0" ]; then
    	tag_variation "${GIT_TAG_NAME}" "mister"
    elif [ "${VERSION}" = "17.1" ]; then
    	tag_variation "${GIT_TAG_NAME}" "mimic"
    	tag_variation "${GIT_TAG_NAME}" "atlas"
    elif [ "${VERSION}" = "18.1" ]; then
    	tag_variation "${GIT_TAG_NAME}" "tc64v2"
    elif [ "${VERSION}" = "21.1" ]; then
    	tag_variation "${GIT_TAG_NAME}" "21.1.1"
    fi
	echo "Done."
}

# Download the software from Intel CDN
download() {
	checkVersion
    echo "Starting download..."
	case $VERSION in
		"13.0")
			echo "Downloading v13.0.1.232sp1..."
			fileArray[0]="13.0sp1/232/ib_installers/QuartusSetupWeb-13.0.1.232.run"
			fileArray[1]="13.0sp1/232/ib_installers/cyclone_web-13.0.1.232.qdz"
			;;
		"13.1")
			echo "Downloading v13.1.0.162"
			fileArray[0]="13.1/162/ib_installers/QuartusSetupWeb-13.1.0.162.run"
			fileArray[1]="13.1/162/ib_installers/cyclone_web-13.1.0.162.qdz"
			fileArray[2]="13.1/162/ib_installers/cyclonev-13.1.0.162.qdz"
			fileArray[2]="13.1.4/182/update/QuartusSetup-13.1.4.182.run"
			;;
		"17.0")
			echo "Downloading v17.0.2.602"
			fileArray[0]="17.0std/595/ib_installers/QuartusLiteSetup-17.0.0.595-linux.run"
			fileArray[1]="17.0std/595/ib_installers/cyclone-17.0.0.595.qdz"
			fileArray[2]="17.0std/595/ib_installers/cyclonev-17.0.0.595.qdz"
			fileArray[3]="17.0std/595/ib_installers/cyclone10lp-17.0.0.595.qdz"
			fileArray[4]="17.0std/595/ib_installers/max10-17.0.0.595.qdz"
			fileArray[5]="17.0std.2/602/update/QuartusSetup-17.0.2.602-linux.run"
			;;
		"17.1")
			echo "Downloading v17.1.1.593"
			fileArray[0]="17.1std/590/ib_installers/QuartusLiteSetup-17.1.0.590-linux.run"
            fileArray[1]="17.1std/590/ib_installers/cyclone-17.1.0.590.qdz"
            fileArray[2]="17.1std/590/ib_installers/cyclonev-17.1.0.590.qdz"
            fileArray[3]="17.1std/590/ib_installers/cyclone10lp-17.1.0.590.qdz"
            fileArray[4]="17.1std/590/ib_installers/max10-17.1.0.590.qdz"
            fileArray[5]="17.1std.1/593/update/QuartusSetup-17.1.1.593-linux.run"
			;;
		"18.1")
			echo "Downloading v18.1.1.646"
			fileArray[0]="18.1std/625/ib_installers/QuartusLiteSetup-18.1.0.625-linux.run"
			fileArray[1]="18.1std/625/ib_installers/cyclone-18.1.0.625.qdz"
			fileArray[2]="18.1std/625/ib_installers/cyclonev-18.1.0.625.qdz"
			fileArray[3]="18.1std/625/ib_installers/cyclone10lp-18.1.0.625.qdz"
			fileArray[4]="18.1std/625/ib_installers/max10-18.1.0.625.qdz"
			fileArray[5]="18.1std.1/646/update/QuartusSetup-18.1.1.646-linux.run"
			;;
		"19.1")
			echo "Downloading v19.1.0.670"
			fileArray[0]="19.1std/670/ib_installers/QuartusLiteSetup-19.1.0.670-linux.run"
            fileArray[1]="19.1std/670/ib_installers/cyclone-19.1.0.670.qdz"
            fileArray[2]="19.1std/670/ib_installers/cyclonev-19.1.0.670.qdz"
            fileArray[3]="19.1std/670/ib_installers/cyclone10lp-19.1.0.670.qdz"
            fileArray[4]="19.1std/670/ib_installers/max10-19.1.0.670.qdz"
			;;
		"20.1")
			echo "Downloading v20.1.0.711"
			fileArray[0]="20.1std/711/ib_installers/QuartusLiteSetup-20.1.0.711-linux.run"
            fileArray[1]="20.1std/711/ib_installers/cyclone-20.1.0.711.qdz"
            fileArray[2]="20.1std/711/ib_installers/cyclonev-20.1.0.711.qdz"
            fileArray[3]="20.1std/711/ib_installers/cyclone10lp-20.1.0.711.qdz"
            fileArray[4]="20.1std/711/ib_installers/max10-20.1.0.711.qdz"
			;;
		"21.1")
			echo "Downloading v21.1.1.850"
			fileArray[0]="21.1std.1/850/ib_installers/QuartusLiteSetup-21.1.1.850-linux.run"
            fileArray[1]="21.1std.1/850/ib_installers/cyclone-21.1.1.850.qdz"
            fileArray[2]="21.1std.1/850/ib_installers/cyclone10lp-21.1.1.850.qdz"
            fileArray[3]="21.1std.1/850/ib_installers/cyclonev-21.1.1.850.qdz"
            fileArray[4]="21.1std.1/850/ib_installers/max10-21.1.1.850.qdz"
			;;
		*)   # Invalid option
			echo "Error: Invalid Version"
			exit
			;;
	esac
	if (( ${#fileArray[@]} )); then
		# Download the files
        for i in "${fileArray[@]}"
		do :
			echo "Checking file status for ${i##*/}..."
			if [ -f "quartus${VERSION}/local/files/${i##*/}" ]; then
				echo "-> Files already exists."
				while read LINE; do
					if [[ $LINE == *"${i##*/}"* ]]; then
                      echo "-> Checking Integrity"
                      pushd "quartus${VERSION}/local/files" > /dev/null || exit
                      hash_res=$(echo "${LINE}" | sha1sum -c -)
                      popd  > /dev/null || exit
                      if [[ $hash_res == *": OK"* ]]; then
						echo "[+] Integrity Check Passed"
					  else
						echo "[-] Integrity Check Failed"
						getfile "${INTEL_CDN}/${i}" "quartus${VERSION}/local/files/${i##*/}"
					  fi
                    fi
				done < "quartus${VERSION}/local/files/file.lst"
			else
				getfile "${INTEL_CDN}/${i}" "quartus${VERSION}/local/files/${i##*/}"
			fi
		done
    else
		echo "Oops, something went wrong..."
	fi
	echo "Operation Complete."
}

################################################################################
# Process the input options. Add options as needed.
################################################################################
# Get the options
while getopts ":lcpogdbv:h:" option; do
	case $option in
		v) # Set the Version
			VERSION=$OPTARG ;;
		d) # Download Quartus Lite files
			download
			exit
			;;
		b) # Build the Container with Remote Files
			build
			exit
			;;
		l) # Build the Container with Local Files
			build_local
			exit
			;;
		c) # Check local file hashes
			check_hash
			exit
			;;
		p) # Push the Container to the Registry
			publish
			exit
			;;
		g) # Push the Container to the GitHub Registry
			publish_to_github
			exit
			;;
		o) # Build Base OS Image
			build_base
			exit
			;;
		*) # Invalid option
			echo "Error: Invalid option"
			exit
			;;
	esac
done


