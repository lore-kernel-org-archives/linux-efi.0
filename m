From: Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 00/14] EFI capsule update support for IOT2000 devices
Date: Wed, 30 Aug 2017 21:13:42 +0200
Message-ID: <cover.1504120436.git.jan.kiszka@siemens.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ben Hutchings <ben.hutchings-4yDnlxn2s6sWdaTGBSpHTA@public.gmane.org>
Cc: cip-dev-Y7OTERR3vatcpJa9FCkz6gFcV7zePqp5@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>, Denys Vlasenko <dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, joeyli <jlee-IBi9RG/b67k@public.gmane.org>, Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kweh Hock Leong <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx@lin>
List-Id: linux-efi@vger.kernel.org

Last chunk: This backports EFI capsule updates, primarily for the use
with the IOT2020 and IOT2040, the latter with Quark-proprietary security
header format. The feature should also work for the Galileo Gen 2 and,
at least conceptually, for any EFI capsule update compatible firmware.

Jan

Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>
Cc: Denys Vlasenko <dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Cc: Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Kweh Hock Leong <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # v4.7
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>

Ard Biesheuvel (3):
  efi/capsule-loader: Use a cached copy of the capsule header
  efi/capsule-loader: Redirect calls to efi_capsule_setup_info() via
    weak alias
  efi/capsule-loader: Use page addresses rather than struct page
    pointers

Austin Christ (1):
  efi/capsule: Allocate whole capsule into virtual memory

Jan Kiszka (5):
  efi/capsule: Fix return code on failing kmap/vmap
  efi/capsule: Remove pr_debug() on ENOMEM or EFAULT
  efi/capsule: Clean up pr_err/_info() messages
  efi/capsule: Adjust return type of efi_capsule_setup_info()
  efi/capsule: Add support for Quark security header

Kweh, Hock Leong (1):
  efi: Add misc char driver interface to update EFI firmware

Matt Fleming (4):
  efi: Move efi_status_to_err() to drivers/firmware/efi/
  efi: Add 'capsule' update support
  x86/efi: Force EFI reboot to process pending capsules
  efi/capsule: Move 'capsule' to the stack in efi_capsule_supported()

 arch/x86/kernel/reboot.c              |   9 +
 arch/x86/platform/efi/quirks.c        | 137 ++++++++++++++
 drivers/firmware/efi/Kconfig          |  19 ++
 drivers/firmware/efi/Makefile         |   2 +
 drivers/firmware/efi/capsule-loader.c | 330 ++++++++++++++++++++++++++++++++++
 drivers/firmware/efi/capsule.c        | 294 ++++++++++++++++++++++++++++++
 drivers/firmware/efi/efi.c            |  33 ++++
 drivers/firmware/efi/reboot.c         |  12 +-
 drivers/firmware/efi/vars.c           |  33 ----
 include/linux/efi.h                   |  34 ++++
 10 files changed, 869 insertions(+), 34 deletions(-)
 create mode 100644 drivers/firmware/efi/capsule-loader.c
 create mode 100644 drivers/firmware/efi/capsule.c

-- 
2.12.3
