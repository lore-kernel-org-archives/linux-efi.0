From: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 1/8] x86, kaslr: get kaslr_enabled back correctly
Date: Mon, 2 Mar 2015 10:58:23 -0800
Message-ID: <CAE9FiQV-xSqi-KqgafFL87epGobKmz6Ci_ood3ZtDSFPgSuG6Q@mail.gmail.com>
References: <CAE9FiQXE5YnSQAkkAxob38Qe+aHZ=niAXL6uLF5650KQPfjPPw@mail.gmail.com>
	<20150301094557.GA7748@pd.tnic>
	<20150301152351.GA17391@gmail.com>
	<CAE9FiQV7DouV+76mzH0jFjFJOFBm-ZmgKpYVjTGAmKao0y3HbA@mail.gmail.com>
	<20150301194904.GC7748@pd.tnic>
	<CAE9FiQVpWQ1NU5Euy2G4btS=94qKCZZ7T0YFsCR1x6iv4C1hjA@mail.gmail.com>
	<20150301202938.GD7748@pd.tnic>
	<CAE9FiQWqfpCg5reKP5TOv=8qJCLxqBDHCKAexH94avZ4b3=irQ@mail.gmail.com>
	<20150302085654.GA17532@pd.tnic>
	<CAE9FiQVS0ai2k-WNfsbwvOkj8YUxzaZJN5XDTMu1Ukhot7zOTw@mail.gmail.com>
	<20150302145313.GC17532@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <20150302145313.GC17532@pd.tnic>
Sender: linux-pci-owner@vger.kernel.org
To: Borislav Petkov <bp@suse.de>
Cc: Ingo Molnar <mingo@kernel.org>, Jiri Kosina <jkosina@suse.cz>, Kees Cook <keescook@chromium.org>, Matt Fleming <matt.fleming@intel.com>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Mar 2, 2015 at 6:53 AM, Borislav Petkov <bp@suse.de> wrote:
> Well, it seems to work here but it still doesn't look reliable enough to
> me. And this addon_zo thing of arbitrary 256K is strange.

Thanks for check that out.

That is not arbitrary number. Need to make that bigger than _end - _rodata

> objdump -t arch/x86/boot/compressed/vmlinux | grep \ _end
0000000000996000 g       .pgtable    0000000000000000 _end
> objdump -t arch/x86/boot/compressed/vmlinux | grep \ _rodata
0000000000981780 g       .rodata    0000000000000000 _rodata

We only get that size after arch/x86/boot/compressed/vmlinux

but need number during building kernel vmlinux.

other way would be just increase init_size in arch/x86/boot/header.S
instead of put it BRK area.

Thanks

Yinghai
