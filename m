From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [GIT PULL 00/14] EFI changes for v4.6
Date: Mon,  1 Feb 2016 22:06:54 +0000
Message-ID: <1454364428-494-1-git-send-email-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Geliang Tang <geliangtang@163.com>, Josh Triplett <josh@joshtriplett.org>, Laszlo Ersek <lersek@redhat.com>, Leif Lindholm <leif.lindholm@linaro.org>, =?UTF-8?q?M=C3=B4she=20van=20der=20Sterre?= <me@moshe.nl>, Peter Jones <pjones@redhat.com>, Robert Elliott <elliott@hpe.com>, Taku Izumi <izumi.taku@jp.fujitsu.com>
List-Id: linux-efi@vger.kernel.org

=46olks, please pull the following changes for v4.6. This mostly
consists of cleanups but the patches to execute EFI runtime services
with interrupts enabled would benefit from a thorough baking in
linux-next.

I'm sending this pull nice and early so that we can shake out any bugs
before the next merge window.

The following changes since commit 753b11ef8e92a1c1bbe97f2a5ec14bdd1ef2=
e6fe:

  x86/efi: Setup separate EFI page tables in kexec paths (2016-01-21 21=
:01:34 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/e=
fi-next

for you to fetch changes up to 921c2e93a5d7f14a803663389b9541f14744d048=
:

  x86/efi: Print size in binary units in efi_print_memmap (2016-02-01 2=
0:52:49 +0000)

----------------------------------------------------------------
 * Run EFI runtime services with interrupts enabled for the benefit of
   uniprocessor machines with slow variable stores and because there's
   no good reason to disable them since we don't invoke runtime service=
s
   from IRQ code paths - Ard Biesheuvel

 * Use the existing to_efivar_entry() accessor function in the efivars
   code instead of open-coding it - Geliang Tang

 * Align the ACPI BGRT driver more closely with how Windows interprets
   the 'status' field so we can use the BGRT image - M=C3=B4she van der=
 Sterre

 * checkpatch.pl cleanup of the GUIDs in efi.h which has the added
   benefit of making them more closely resemble how they're presented
   in the UEFI specification - Peter Jones

 * Refactor the x86 EFI memory map printing code and add improved
   support for printing Persistent Memory entries - Robert Elliott,
   Andy Shevchenko

----------------------------------------------------------------
Ard Biesheuvel (7):
      efi: Expose non-blocking set_variable() wrapper to efivars
      efi: Remove redundant efi_set_variable_nonblocking prototype
      efi: runtime-wrappers: Add a nonblocking version of QueryVariable=
Info
      efi: Add nonblocking option to efi_query_variable_store()
      efi: runtime-wrappers: Remove out of date comment regarding in_nm=
i()
      efi: runtime-wrapper: Get rid of the rtc_lock spinlock
      efi: runtime-wrappers: Run UEFI Runtime Services with interrupts =
enabled

Geliang Tang (1):
      efivars: Use to_efivar_entry

M=C3=B4she van der Sterre (1):
      x86/efi-bgrt: Don't ignore the BGRT if the 'valid' bit is 0

Peter Jones (1):
      efi: Make checkpatch complain less about efi.h GUID additions

Robert Elliott (4):
      x86/efi: Show actual ending addresses in efi_print_memmap
      efi: Add NV memory attribute
      efi: Add Persistent Memory type name
      x86/efi: Print size in binary units in efi_print_memmap

 arch/x86/platform/efi/efi-bgrt.c        |  10 +--
 arch/x86/platform/efi/efi.c             |  25 +++++--
 arch/x86/platform/efi/quirks.c          |  33 ++++++++-
 drivers/firmware/efi/efi.c              |   9 ++-
 drivers/firmware/efi/efivars.c          |   2 +-
 drivers/firmware/efi/runtime-wrappers.c | 115 ++++++++++++------------=
--------
 drivers/firmware/efi/vars.c             |  16 ++++-
 include/linux/efi.h                     |  85 ++++++++++++++---------
 8 files changed, 173 insertions(+), 122 deletions(-)
