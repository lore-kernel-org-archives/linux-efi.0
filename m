From: Gary Lin <glin@suse.com>
Subject: [RFC PATCH] x86: Config options to assign versions in the PE-COFF header
Date: Tue, 11 Apr 2017 18:20:41 +0800
Message-ID: <20170411102041.19771-1-glin@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Gary Lin <glin@suse.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Michal Marek <mmarek@suse.com>, Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Joey Lee <jlee@suse.com>, Vojtech Pavlik <vojtech@suse.cz>
List-Id: linux-efi@vger.kernel.org

This commit adds the new config options to allow the user to modify the
following fields in the PE-COFF header.

UINT16 MajorOperatingSystemVersion
UINT16 MinorOperatingSystemVersion
UINT16 MajorImageVersion
UINT16 MinorImageVersion

Those fields are mainly for the executables or libraries in Windows NT
or higher to specify the minimum supported Windows version and the
version of the image itself.

Given the fact that those fields are ignored in UEFI, we can safely reuse
those fields for other purposes, e.g. Security Version(*).

(*) https://github.com/lcp/shim/wiki/Security-Version

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Michal Marek <mmarek@suse.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Joey Lee <jlee@suse.com>
Cc: Vojtech Pavlik <vojtech@suse.cz>
Signed-off-by: Gary Lin <glin@suse.com>
Tested-by: Joey Lee <jlee@suse.com>
---
 arch/x86/Kconfig       |  24 +++++++
 arch/x86/boot/Makefile |  10 +++
 scripts/efiversion.pl  | 192 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 226 insertions(+)
 create mode 100755 scripts/efiversion.pl

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 5bbdef151805..f281c0ff3ff6 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1803,6 +1803,30 @@ config EFI_STUB
 
 	  See Documentation/efi-stub.txt for more information.
 
+config EFI_MAJOR_OS_VERSION
+	hex "EFI Major OS Version"
+	range 0x0 0xFFFF
+	default "0x0"
+	depends on EFI_STUB
+
+config EFI_MINOR_OS_VERSION
+	hex "EFI Minor OS Version"
+	range 0x0 0xFFFF
+	default "0x0"
+	depends on EFI_STUB
+
+config EFI_MAJOR_IMAGE_VERSION
+	hex "EFI Major Image Version"
+	range 0x0 0xFFFF
+	default "0x0"
+	depends on EFI_STUB
+
+config EFI_MINOR_IMAGE_VERSION
+	hex "EFI Minor Image Version"
+	range 0x0 0xFFFF
+	default "0x0"
+	depends on EFI_STUB
+
 config EFI_MIXED
 	bool "EFI mixed-mode support"
 	depends on EFI_STUB && X86_64
diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index 0d810fb15eac..b9de8b50f32a 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -76,8 +76,18 @@ quiet_cmd_image = BUILD   $@
 cmd_image = $(obj)/tools/build $(obj)/setup.bin $(obj)/vmlinux.bin \
 			       $(obj)/zoffset.h $@
 
+cmd_efiversion = scripts/efiversion.pl \
+			--major-os=$(CONFIG_EFI_MAJOR_OS_VERSION) \
+			--minor-os=$(CONFIG_EFI_MINOR_OS_VERSION) \
+			--major-image=$(CONFIG_EFI_MAJOR_IMAGE_VERSION) \
+			--minor-image=$(CONFIG_EFI_MINOR_IMAGE_VERSION) \
+			$@
+
 $(obj)/bzImage: $(obj)/setup.bin $(obj)/vmlinux.bin $(obj)/tools/build FORCE
 	$(call if_changed,image)
+ifeq ($(CONFIG_EFI_STUB),y)
+	$(call if_changed,efiversion,$@)
+endif
 	@echo 'Kernel: $@ is ready' ' (#'`cat .version`')'
 
 OBJCOPYFLAGS_vmlinux.bin := -O binary -R .note -R .comment -S
diff --git a/scripts/efiversion.pl b/scripts/efiversion.pl
new file mode 100755
index 000000000000..fe730d10638a
--- /dev/null
+++ b/scripts/efiversion.pl
@@ -0,0 +1,192 @@
+#!/usr/bin/perl
+
+=head1 efiversion.pl
+
+efiversion.pl - show or modify the version fields in the EFI image
+
+=head1 SYNOPSIS
+
+efiversion.pl [OPTIONS] FILE
+
+=head1 OPTIONS
+
+=over 4
+
+=item B<--major-os=NUMBER>
+
+assign the major OS version
+
+=item B<--minor-os=NUMBER>
+
+assign the minor OS version
+
+=item B<--major-image=NUMBER>
+
+assign the major image version
+
+=item B<--minor-image=NUMBER>
+
+assign the minor image version
+
+=item B<--help, -h>
+
+print help
+
+=back
+
+=head1 DESCRIPTION
+
+A script to modify the version fields in the header of the EFI image
+
+Show the versions:
+$ efiversion.pl sample.efi
+
+Modify the versions:
+$ efiversion.pl --major-os=1 --minor-os=2 sample.efi
+
+=cut
+
+use strict;
+use warnings;
+use FileHandle;
+use Getopt::Long;
+Getopt::Long::Configure("no_ignore_case");
+
+my %options;
+
+sub usage($) {
+	my $r = shift;
+	eval "use Pod::Usage; pod2usage($r);";
+	if ($@) {
+		die "cannot display help, install perl(Pod::Usage)\n";
+	}
+}
+
+my $options;
+my $major_os = '';
+my $minor_os = '';
+my $major_image = '';
+my $minor_image = '';
+my $help = '';
+my $overwrite = '';
+
+GetOptions(
+	"major-os=o" => \$major_os,
+	"minor-os=o" => \$minor_os,
+	"major-image=o" => \$major_image,
+	"minor-image=o" => \$minor_image,
+	"help|h" => \$help,
+) or usage(1);
+
+usage(1) unless @ARGV;
+usage(0) if ($help);
+
+sub not_ushort($)
+{
+	my ($number) = @_;
+
+	return 0 unless $number;
+	return 1 if ($number < 0 or $number > 0xFFFF);
+
+	$overwrite = "y";
+
+	return 0;
+}
+
+sub check_args
+{
+	return 0 if not_ushort($major_os);
+	return 0 if not_ushort($minor_os);
+	return 0 if not_ushort($major_image);
+	return 0 if not_ushort($minor_image);
+	return 1;
+}
+
+sub read_file($)
+{
+	my ($file) = @_;
+	my $contents;
+	my $len;
+
+	open(FD, "<$file") || die $file;
+	binmode FD;
+	my @st = stat(FD);
+	die $file if (!@st);
+	$len = read(FD, $contents, $st[7]) || die $file;
+	close(FD) || die $file;
+	die "$file: Wanted length ", $st[7], ", got ", $len, "\n"
+		if ($len != $st[7]);
+	return $contents;
+}
+
+sub get_signature_offset($)
+{
+	my ($image) = @_;
+
+	# e_magic must be 'M''Z'
+	my ($e_magic) = unpack("n", substr($image, 0, 2));
+	die "not a EFI Image\n" unless ($e_magic == 0x4D5A);
+
+	# Get the offset to the PE signature
+	my ($e_lfanew) = unpack("V", substr($image, 0x3C, 4));
+
+	# Match Signature 'P''E''\0''\0'
+	my ($Signature) = unpack("N", substr($image, $e_lfanew, 4));
+	die "not a PE Image\n" unless ($Signature == 0x50450000);
+
+	return $e_lfanew;
+}
+
+sub write_file($)
+{
+	my ($file, $contents) = @_;
+
+	open(FD, ">$file") || die $file;
+	binmode FD;
+	print FD $contents;
+	close(FD) || die $file;
+}
+
+sub set_version($)
+{
+	my ($image_ptr, $offset, $value) = @_;
+	my $packed = pack("v", $value);
+	substr($$image_ptr, $offset, 2, $packed);
+}
+
+die "invalid arguments\n" unless check_args;
+
+my ($file) = @ARGV;
+my $pe_image = read_file($file) if ($file);
+my $e_lfanew = get_signature_offset($pe_image);
+
+# [PE Signature][COFF File Header][Optional Header]
+#     4 bytes        20 bytes
+#
+# The offset of MajorOperatingSystemVersion in the Optional Header: 40
+#
+# The file offset of MajorOperatingSystemVersion: $e_lfanew + 24 + 40
+#
+# Our targets:
+#   UINT16  MajorOperatingSystemVersion;
+#   UINT16  MinorOperatingSystemVersion;
+#   UINT16  MajorImageVersion;
+#   UINT16  MinorImageVersion;
+my $os_offset = $e_lfanew + 64;
+
+if ($overwrite) {
+	# Write the file
+	&set_version(\$pe_image, $os_offset,     $major_os)     if ($major_os);
+	&set_version(\$pe_image, $os_offset + 2, $minor_os)     if ($minor_os);
+	&set_version(\$pe_image, $os_offset + 4, $major_image)  if ($major_image);
+	&set_version(\$pe_image, $os_offset + 6, $minor_image)  if ($minor_image);
+	&write_file($file, $pe_image);
+} else {
+	# Get the versions
+	(my @versions) = unpack("v6", substr($pe_image, $os_offset, 12));
+
+	printf "MajorOperatingSystemVersion\t0x%X\n", $versions[0];
+	printf "MinorOperatingSystemVersion\t0x%X\n", $versions[1];
+	printf "MajorImageVersion\t\t0x%X\n",         $versions[2];
+	printf "MinorImageVersion\t\t0x%X\n",         $versions[3];
+}
-- 
2.12.0
