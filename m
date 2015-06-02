From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [GIT PULL] EFI changes for v4.2
Date: Tue, 2 Jun 2015 08:45:57 +0200
Message-ID: <20150602064557.GB31128@gmail.com>
References: <20150531162559.GA6826@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150531162559.GA6826@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Peter Jones <pjones@redhat.com>
List-Id: linux-efi@vger.kernel.org


* Matt Fleming <matt@codeblueprint.co.uk> wrote:

> Hi folks,
> 
> Please pull the following new material for v4.2. The most interesting
> change is support for the EFI System Resource Table contributed by Peter
> Jones. ESRT is new in the UEFI 2.5 specification (released April 2015)
> and is used by Fedora's fwupdate tool when performing firmware updates.
> 
> The following changes since commit b787f68c36d49bb1d9236f403813641efa74a031:
> 
>   Linux 4.1-rc1 (2015-04-26 17:59:10 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-next
> 
> for you to fetch changes up to c208358c2cc832eeb5b341a465eee30be19cd5a0:
> 
>   efi: Add 'systab' information to Documentation/ABI (2015-05-27 15:40:20 +0100)
> 
> ----------------------------------------------------------------
>  * Use idiomatic negative error values in efivar_create_sysfs_entry()
>    instead of returning '1' to indicate error - Dan Carpenter
> 
>  * New support to expose the EFI System Resource Tables in sysfs, which
>    provides information for performing firmware updates - Peter Jones
> 
>  * Documentation cleanup in the EFI handover protocol section which
>    falsely claimed that 'cmdline_size' needed to be filled out by the
>    boot loader - Alex Smith
> 
>  * Align the order of SMBIOS tables in /sys/firmware/efi/systab to match
>    the way that we do things for ACPI and add documentation to
>    Documentation/ABI - Jean Delvare
> 
> ----------------------------------------------------------------
> Alex Smith (1):
>       x86, doc: Remove cmdline_size from list of fields to be filled in for EFI handover
> 
> Dan Carpenter (1):
>       efi: efivar_create_sysfs_entry() should return negative error codes
> 
> Jean Delvare (1):
>       efi: dmi: List SMBIOS3 table before SMBIOS table
> 
> Matt Fleming (1):
>       efi: Add 'systab' information to Documentation/ABI
> 
> Peter Jones (2):
>       efi: Add esrt support
>       efi/esrt: Fix some compiler warnings
> 
>  Documentation/ABI/testing/sysfs-firmware-efi      |  10 +
>  Documentation/ABI/testing/sysfs-firmware-efi-esrt |  81 ++++
>  Documentation/x86/boot.txt                        |   1 -
>  arch/x86/platform/efi/efi.c                       |   2 +
>  drivers/firmware/efi/Makefile                     |   2 +-
>  drivers/firmware/efi/efi.c                        |  91 ++++-
>  drivers/firmware/efi/efivars.c                    |  11 +-
>  drivers/firmware/efi/esrt.c                       | 471 ++++++++++++++++++++++
>  include/linux/efi.h                               |   8 +
>  9 files changed, 667 insertions(+), 10 deletions(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-firmware-efi-esrt
>  create mode 100644 drivers/firmware/efi/esrt.c

Pulled, thanks a lot Matt!

I'm wondering about this commit:

  f2f6b587c553 ("efi/esrt: Fix some compiler warnings")

It says, in part:

 This patch also fixes one other warning about an uninitialized variable
 some compiler versions seem to see.  You can't actually hit the code
 path where it would be uninitialized, because there's a prior test that
 would error out, but gcc hasn't figured that out.  Anyway, it now has a
 test and returns the error at both places.

@@ -167,7 +167,6 @@ static struct kset *esrt_kset;
 
 static int esre_create_sysfs_entry(void *esre, int entry_num)
 {
-       int rc = 0;
        struct esre_entry *entry;
        char name[20];
 
@@ -180,13 +179,15 @@ static int esre_create_sysfs_entry(void *esre, int entry_num)
        entry->kobj.kset = esrt_kset;
 
        if (esrt->fw_resource_version == 1) {
+               int rc = 0;
+
                entry->esre.esre1 = esre;
                rc = kobject_init_and_add(&entry->kobj, &esre1_ktype, NULL,
                                          "%s", name);
-       }
-       if (rc) {
-               kfree(entry);
-               return rc;
+               if (rc) {
+                       kfree(entry);
+                       return rc;
+               }
        }
 
        list_add_tail(&entry->list, &entry_list);

How can a compiler ever have warned about 'rc' being uninitialized? It's defined 
straight at function entry, with initialization to 0. It can never be 
uninitialized.

I pulled it, because I agree with the change itself, as it's always better to 
define and use variables in the narrowest scope possible, but I think it's a 
cleanup, not a compiler warning fix.

Thanks,

	Ingo
