From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [GIT PULL 0/2] EFI urgent fixes
Date: Tue, 16 Feb 2016 12:59:18 +0000
Message-ID: <1455627560-10576-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Fleming <matt@codeblueprint.co.uk>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Jason Andryuk <jandryuk@gmail.com>, Laszlo Ersek <lersek@redhat.com>, "Lee, Chun-Yi" <jlee@suse.com>, Matthew Garrett <mjg59@coreos.com>, Peter Jones <pjones@redhat.com>
List-Id: linux-efi@vger.kernel.org

Folks, here are some bug fixes that missed the previous pull request
but that are related to those patches.

The following changes since commit 4682c211a80ee93214b72d95f861b0f6e90e5445:

  Merge tag 'efi-urgent' of git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi into x86/urgent (2016-02-16 13:14:57 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent

for you to fetch changes up to a68075908a37850918ad96b056acc9ac4ce1bd90:

  lib/ucs2_string: Correct ucs2 -> utf8 conversion (2016-02-16 12:49:05 +0000)

----------------------------------------------------------------
 * Fix bugs in our code that converts ucs2 strings to utf8 where we
   unintentionally drop bits from the original string - Jason Andryuk

 * Add the efi-pstore variables to the variable whitelist so that
   users can continue to delete them via efivarfs without needing to
   manipulate the immutable flag - Matt Fleming

----------------------------------------------------------------
Jason Andryuk (1):
      lib/ucs2_string: Correct ucs2 -> utf8 conversion

Matt Fleming (1):
      efi: Add pstore variables to the deletion whitelist

 drivers/firmware/efi/vars.c |  1 +
 lib/ucs2_string.c           | 14 +++++++-------
 2 files changed, 8 insertions(+), 7 deletions(-)
