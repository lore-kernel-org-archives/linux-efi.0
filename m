From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [GIT PULL 0/1] EFI fix for v4.16
Date: Tue, 13 Mar 2018 14:09:20 +0000
Message-ID: <20180313140922.17266-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: hdegoede@redhat.com, tweek@google.com, javierm@redhat.com, jarkko.sakkinen@linux.intel.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, Jeremy Cline <jeremy@jcline.org>
List-Id: linux-efi@vger.kernel.org

The following changes since commit 7928b2cbe55b2a410a0f5c1f154610059c57b1b2:

  Linux 4.16-rc1 (2018-02-11 15:04:29 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-urgent

for you to fetch changes up to 5c4d724b7ccfa934b95c5c49fab770035a425950:

  efi/libstub: tpm: zero initialize pointer variables for mixed mode (2018-03-13 13:48:25 +0000)

----------------------------------------------------------------
EFI fix for v4.16:
- fix an issue in the mixed mode handling of the new TPM libstub code

----------------------------------------------------------------
Ard Biesheuvel (1):
      efi/libstub: tpm: zero initialize pointer variables for mixed mode

 drivers/firmware/efi/libstub/tpm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)
