From: Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH v2 04/15] x86, kaslr: get kaslr_enabled back correctly
Date: Sat, 7 Mar 2015 22:05:14 +0100
Message-ID: <20150307210514.GC3380@pd.tnic>
References: <1425456048-16236-1-git-send-email-yinghai@kernel.org>
 <1425456048-16236-5-git-send-email-yinghai@kernel.org>
 <20150304101649.GA3663@pd.tnic>
 <CAE9FiQWKNDgzJtDVV34e7vWTu7LtqdDKB4KiN1RZwcZrX70zSA@mail.gmail.com>
 <20150304200000.GB6276@gmail.com>
 <CAE9FiQXJ-ujbhpw8phk5iQM8QFw=9QxDrXK6AdyXqDxmch_bbw@mail.gmail.com>
 <20150306133312.GC4259@pd.tnic>
 <CAE9FiQVt8Bi==r7pPhSOcSTmmpkjZ4c7O6iphbzFkgbugzKbqw@mail.gmail.com>
 <CAE9FiQXbQ37A7+a+dk4LdPs7DCr68EfWwypR9X4dyPfixH8PZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAE9FiQXbQ37A7+a+dk4LdPs7DCr68EfWwypR9X4dyPfixH8PZA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Jiri Kosina <jkosina@suse.cz>, Baoquan He <bhe@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, Kees Cook <keescook@chromium.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Mar 06, 2015 at 11:53:22AM -0800, Yinghai Lu wrote:
> That will get wrong value back for kaslr_enabled in kernel stage.
> 1. When kaslr is not enabled at boot/choose_kernel_location, if kaslr_enabled
> get set wrongly in setup.c, late in module.c::get_module_load_offset
> will return not wanted random module load offset.
> That change behavior when HIBERNATION is defined or nokaslr is passed.
> 
> 2. When kaslr is enabled at boot/choose_kernel_location, if kaslr_enabled
> get cleared wrongly in setup.c, late in module.c::get_module_load_offset
> will not return wanted random module load offset.

Now you went from the one extreme to the other. Initially it was
"trivial and obvious" now it is too much unreadable detail which no one
needs.

How about this:

---
Commit

  f47233c2d34f ("x86/mm/ASLR: Propagate base load address calculation")

started passing KASLR status to kernel proper, but it uses a physical
address as the vaule, leading to parsing bogus KASLR status in kernel
proper.

The setup_data linked list and thus the element which contains
kaslr_enabled is chained together using physical addresses. At the time
when we access it in the kernel proper, we're already running with
paging enabled and therefore must access it through its virtual address.

This patch changes the code to use early_memmap() and access the value.
---

Complaints?

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
