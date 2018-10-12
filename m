From: Dmitry Safonov <dima@arista.com>
Subject: [RFC-resend 0/2] compat: in_compat_syscall() differs on x86
Date: Fri, 12 Oct 2018 14:42:51 +0100
Message-ID: <20181012134253.23266-1-dima@arista.com>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Dmitry Safonov <0x7f454c46@gmail.com>, Dmitry Safonov <dima@arista.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andy Lutomirsky <luto@kernel.org>, "David S. Miller" <davem@davemloft.net>, Herbert Xu <herbert@gondor.apana.org.au>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, John Stultz <john.stultz@linaro.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Oleg Nesterov <oleg@redhat.com>, Steffen Klassert <steffen.klassert@secunet.com>, Stephen Boyd <sboyd@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org, linux-efi@vger.kernel.org, netdev@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Reading xfrm (ipsec) code I've found such code:

: #ifdef CONFIG_COMPAT
:         if (in_compat_syscall())
:                 return -EOPNOTSUPP;
: #endif

While I can read that it's false on native i386, it's a bit misleading
and in result it's better to introduce a helper for that.
Grepping other code, I've found that there are already such helpers.
And the uniq behavior of in_compat_syscall() on x86 is disturbing.

Adjusting it to generic with the following..

(on the first non-resend RFC I managed to forget Cc'ing Andy..
 sorry about that, was sure I did add him).

Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Andy Lutomirsky <luto@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Stephen Boyd <sboyd@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: x86@kernel.org
Cc: linux-efi@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: Dmitry Safonov <0x7f454c46@gmail.com>

Dmitry Safonov (2):
  x86/compat: Adjust in_compat_syscall() to generic code under !COMPAT
  compat: Cleanup in_compat_syscall() callers

 arch/x86/include/asm/compat.h  |  9 ++++++++-
 arch/x86/include/asm/ftrace.h  |  4 +---
 arch/x86/kernel/process_64.c   |  4 ++--
 arch/x86/kernel/sys_x86_64.c   | 11 ++++++-----
 arch/x86/mm/hugetlbpage.c      |  4 ++--
 arch/x86/mm/mmap.c             |  2 +-
 drivers/firmware/efi/efivars.c | 16 ++++------------
 include/linux/compat.h         |  4 ++--
 kernel/time/time.c             |  2 +-
 net/xfrm/xfrm_state.c          |  2 --
 net/xfrm/xfrm_user.c           |  2 --
 11 files changed, 27 insertions(+), 33 deletions(-)

-- 
2.13.6
