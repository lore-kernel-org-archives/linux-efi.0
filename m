From: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH v2 04/15] x86, kaslr: get kaslr_enabled back correctly
Date: Sat, 7 Mar 2015 13:11:04 -0800
Message-ID: <CAE9FiQWVdzX=eDGEz3u906TYTagps0VZsSWKHRqJro8wfgGjeg@mail.gmail.com>
References: <1425456048-16236-1-git-send-email-yinghai@kernel.org>
	<1425456048-16236-5-git-send-email-yinghai@kernel.org>
	<20150304101649.GA3663@pd.tnic>
	<CAE9FiQWKNDgzJtDVV34e7vWTu7LtqdDKB4KiN1RZwcZrX70zSA@mail.gmail.com>
	<20150304200000.GB6276@gmail.com>
	<CAE9FiQXJ-ujbhpw8phk5iQM8QFw=9QxDrXK6AdyXqDxmch_bbw@mail.gmail.com>
	<20150306133312.GC4259@pd.tnic>
	<CAE9FiQVt8Bi==r7pPhSOcSTmmpkjZ4c7O6iphbzFkgbugzKbqw@mail.gmail.com>
	<CAE9FiQXbQ37A7+a+dk4LdPs7DCr68EfWwypR9X4dyPfixH8PZA@mail.gmail.com>
	<20150307210514.GC3380@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150307210514.GC3380@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@suse.de>
Cc: Ingo Molnar <mingo@kernel.org>, Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Jiri Kosina <jkosina@suse.cz>, Baoquan He <bhe@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, Kees Cook <keescook@chromium.org>
List-Id: linux-efi@vger.kernel.org

On Sat, Mar 7, 2015 at 1:05 PM, Borislav Petkov <bp@suse.de> wrote:
> On Fri, Mar 06, 2015 at 11:53:22AM -0800, Yinghai Lu wrote:
> ---
> Commit
>
>   f47233c2d34f ("x86/mm/ASLR: Propagate base load address calculation")
>
> started passing KASLR status to kernel proper, but it uses a physical
> address as the vaule, leading to parsing bogus KASLR status in kernel
> proper.
>
> The setup_data linked list and thus the element which contains
> kaslr_enabled is chained together using physical addresses. At the time
> when we access it in the kernel proper, we're already running with
> paging enabled and therefore must access it through its virtual address.
>
> This patch changes the code to use early_memmap() and access the value.
> ---

Good to me.
