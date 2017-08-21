From: Evgeny Laktanov <anulap4lists-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Thinkpad e545 woes
Date: Mon, 21 Aug 2017 12:25:15 +0300
Message-ID: <CAE_LcB=Yb0xiC0YpdMLhgaJC40xDWv6s__enCGLo4TwnjLX6Fw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

I've decided to try my hand at solving
https://bugzilla.kernel.org/show_bug.cgi?id=195035, as it seems to
only affect me, or at least people have been quiet about it.

I've debugged the issue a bit and it is basically a SIGSEGV type of
event. In efi_clean_memmap efi.memmap.map returns pointer to address
0xfffffffffff200000, which is obviously wrong, after which any
attempts to validate
in efi_memmap_entry_valid cause a panic, because of bogus pointer.

Git bisects won't help much, because the issue was always present
apparently, it just wasn't fatal (as seen in dmesg attached to the
bug).

I am kinda new to kernel programming in general, so I am seeking
advice for debugging this.

Sincerely, Evgeny
