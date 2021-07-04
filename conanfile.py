from conans import ConanFile, tools


class libBigWig(ConanFile):
    # Note: options are copied from CMake boolean options.
    # When turned off, CMake sometimes passes them as empty strings.
    options = {
        "with_curl": ["ON", "OFF", True, False, ""]
    }

    default_options = {"with_curl": "ON"}

    name = "libBigWig"
    version = "0.4.6"
    homepage = "https://github.com/robomics/libBigWig"
    license = "MIT"
    settings = "os", "compiler", "build_type", "arch"
    requires = ["zlib/1.2.11"]

    generators = "cmake"

    def requirements(self):
        if bool(self.options.with_curl):
            self.requires("libcurl/7.77.0")
