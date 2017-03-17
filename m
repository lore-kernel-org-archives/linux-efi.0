From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [GIT PULL] UEFI fix for v4.11-rc
Date: Fri, 17 Mar 2017 19:06:44 +0000
Message-ID: <1489777605-8363-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, Daniel Drake <drake@endlessm.com>, Matt Fleming <matt@codeblueprint.co.uk>, Peter Jones <pjones@redhat.com>
List-Id: linux-efi@vger.kernel.org

Hi all,

At Matt's request, we are proposing this single patch as a bugfix for v4.11.
Please pull.

The following changes since commit 4495c08e84729385774601b5146d51d9e5849f81:

  Linux 4.11-rc2 (2017-03-12 14:47:08 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-urgent

for you to fetch changes up to 822f5845f710e57d7e2df1fd1ee00d6e19d334fe:

  efi/esrt: Cleanup bad memory map log messages (2017-03-17 18:53:12 +0000)

----------------------------------------------------------------
A single UEFI fix:
- Reduce the severity of the notice that appears when the ESRT table points
  to memory that is not covered by the memory map. It is scaring our users
  and interfering with their nice splash screens. Note that the ESRT may still
  be perfectly usable, and is currently (to my knowledge) not widely used to
  begin with.

----------------------------------------------------------------
Daniel Drake (1):
      efi/esrt: Cleanup bad memory map log messages

 drivers/firmware/efi/efi.c  | 1 -
 drivers/firmware/efi/esrt.c | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)
