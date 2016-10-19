From: Laura Abbott <labbott@redhat.com>
Subject: [REGRESSION] EFI mixed mode patch triggers boot failure
Date: Wed, 19 Oct 2016 13:04:36 -0700
Message-ID: <dc0bc031-f20e-9ad0-57f4-cfa1e04f8f05@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: "x86@kernel.org" <x86@kernel.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Justin Forbes <jforbes@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

Hi,

Fedora received a bug report https://bugzilla.redhat.com/show_bug.cgi?id=1384238
of a bootup failure with stable 4.7.6. efi=noruntime fixed the bootup problem.
1297667083d5442aafe3e337b9413bf02b114edb was linked as the cause
of the problem.


x86/efi: Only map RAM into EFI page tables if in mixed-mode

Waiman reported that booting with CONFIG_EFI_MIXED enabled on his
multi-terabyte HP machine results in boot crashes, because the EFI
region mapping functions loop forever while trying to map those
regions describing RAM.

While this patch doesn't fix the underlying hang, there's really no
reason to map EFI_CONVENTIONAL_MEMORY regions into the EFI page tables
when mixed-mode is not in use at runtime.

Reported-by: Waiman Long <waiman.long@hpe.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
CC: Theodore Ts'o <tytso@mit.edu>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Scott J Norton <scott.norton@hpe.com>
Cc: Douglas Hatch <doug.hatch@hpe.com>
Cc: <stable@vger.kernel.org> # v4.6+
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>

I made a request in the bugzilla for the reporter to
give a bootlog with efi=debug which I'm still waiting on.

Any ideas?

Thanks,
Laura
