From: Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH v2 04/15] x86, kaslr: get kaslr_enabled back correctly
Date: Fri, 6 Mar 2015 14:33:12 +0100
Message-ID: <20150306133312.GC4259@pd.tnic>
References: <1425456048-16236-1-git-send-email-yinghai@kernel.org>
 <1425456048-16236-5-git-send-email-yinghai@kernel.org>
 <20150304101649.GA3663@pd.tnic>
 <CAE9FiQWKNDgzJtDVV34e7vWTu7LtqdDKB4KiN1RZwcZrX70zSA@mail.gmail.com>
 <20150304200000.GB6276@gmail.com>
 <CAE9FiQXJ-ujbhpw8phk5iQM8QFw=9QxDrXK6AdyXqDxmch_bbw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAE9FiQXJ-ujbhpw8phk5iQM8QFw=9QxDrXK6AdyXqDxmch_bbw@mail.gmail.com>
Sender: linux-pci-owner@vger.kernel.org
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Jiri Kosina <jkosina@suse.cz>, Baoquan He <bhe@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, Kees Cook <keescook@chromium.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Mar 04, 2015 at 01:32:53PM -0800, Yinghai Lu wrote:
> On Wed, Mar 4, 2015 at 12:00 PM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > It is totally unacceptable that you don't do proper analysis of the
> > patches you submit, and that you don't bother writing proper, readable
> > changelogs.
> 
> Sorry, please check it again:
> 
> Subject: [PATCH v4] x86, kaslr: Get kaslr_enabled back correctly

Subject: x86/kaslr: Access the correct kaslr_enabled variable

> commit f47233c2d34f ("x86/mm/ASLR: Propagate base load address calculation")
> is using address as value for kaslr_enabled.

"commit ... started passing KASLR status to kernel proper."

> That will get wrong value back for kaslr_enabled in kernel stage.
> 1. When kaslr is not enabled at boot/choose_kernel_location, if kaslr_enabled
> get set wrongly in setup.c, late in module.c::get_module_load_offset
> will return not wanted random module load offset.
> That change behavior when HIBERNATION is defined or nokaslr is passed.
> 
> 2. When kaslr is enabled at boot/choose_kernel_location, if kaslr_enabled
> get cleared wrongly in setup.c, late in module.c::get_module_load_offset
> will not return wanted random module load offset.
> 
> This patch changes the code to use early_memmap and access the value,
> and will keep boot and kernel consistent with kaslr.

Replace all that with:

"However, the setup_data linked list and thus the element which contains
kaslr_enabled is chained together using physical addresses. At the
time when we access it in the kernel proper, we're already running
with paging enabled and therefore must access it through its virtual
address."

That's it, now how hard was to explain it that way?

> -v3: add checking return from early_memmap according to bp.

I guess with "bp" you mean me? You can call me Boris.

> Fixes: f47233c2d34f ("x86/mm/ASLR: Propagate base load address calculation")
> Cc: Matt Fleming <matt.fleming@intel.com>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Jiri Kosina <jkosina@suse.cz>
> Acked-by: Jiri Kosina <jkosina@suse.cz>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/kernel/setup.c |   13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/arch/x86/kernel/setup.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/setup.c
> +++ linux-2.6/arch/x86/kernel/setup.c
> @@ -429,7 +429,18 @@ static void __init reserve_initrd(void)
> 
>  static void __init parse_kaslr_setup(u64 pa_data, u32 data_len)
>  {
> -    kaslr_enabled = (bool)(pa_data + sizeof(struct setup_data));
> +    /* kaslr_setup_data is defined in aslr.c */
> +    unsigned char *data;
> +    unsigned long offset = sizeof(struct setup_data);
> +
> +    data = early_memremap(pa_data, offset + 1);
> +    if (!data) {
> +        kaslr_enabled = true;
> +        return;
> +    }
> +
> +    kaslr_enabled = *(data + offset);
> +    early_memunmap(data, offset + 1);
>  }
> 
>  static void __init parse_setup_data(void)

Please use checkpatch before submitting patches:

WARNING: please, no spaces at the start of a line
#71: FILE: arch/x86/kernel/setup.c:433:
+    unsigned char *data;$

WARNING: please, no spaces at the start of a line
#72: FILE: arch/x86/kernel/setup.c:434:
+    unsigned long offset = sizeof(struct setup_data);$

WARNING: please, no spaces at the start of a line
#74: FILE: arch/x86/kernel/setup.c:436:
+    data = early_memremap(pa_data, offset + 1);$

WARNING: please, no spaces at the start of a line
#75: FILE: arch/x86/kernel/setup.c:437:
+    if (!data) {$

ERROR: code indent should use tabs where possible
#76: FILE: arch/x86/kernel/setup.c:438:
+        kaslr_enabled = true;$

WARNING: please, no spaces at the start of a line
#76: FILE: arch/x86/kernel/setup.c:438:
+        kaslr_enabled = true;$

ERROR: code indent should use tabs where possible
#77: FILE: arch/x86/kernel/setup.c:439:
+        return;$

WARNING: please, no spaces at the start of a line
#77: FILE: arch/x86/kernel/setup.c:439:
+        return;$

WARNING: please, no spaces at the start of a line
#78: FILE: arch/x86/kernel/setup.c:440:
+    }$

WARNING: please, no spaces at the start of a line
#80: FILE: arch/x86/kernel/setup.c:442:
+    kaslr_enabled = *(data + offset);$

WARNING: please, no spaces at the start of a line
#81: FILE: arch/x86/kernel/setup.c:443:
+    early_memunmap(data, offset + 1);$

total: 2 errors, 9 warnings, 19 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

Your patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
