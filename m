From: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH v2 04/15] x86, kaslr: get kaslr_enabled back correctly
Date: Wed, 4 Mar 2015 13:32:53 -0800
Message-ID: <CAE9FiQXJ-ujbhpw8phk5iQM8QFw=9QxDrXK6AdyXqDxmch_bbw@mail.gmail.com>
References: <1425456048-16236-1-git-send-email-yinghai@kernel.org>
	<1425456048-16236-5-git-send-email-yinghai@kernel.org>
	<20150304101649.GA3663@pd.tnic>
	<CAE9FiQWKNDgzJtDVV34e7vWTu7LtqdDKB4KiN1RZwcZrX70zSA@mail.gmail.com>
	<20150304200000.GB6276@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150304200000.GB6276@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>, Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@suse.de>, Baoquan He <bhe@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, Kees Cook <keescook@chromium.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Mar 4, 2015 at 12:00 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> It is totally unacceptable that you don't do proper analysis of the
> patches you submit, and that you don't bother writing proper, readable
> changelogs.

Sorry, please check it again:

Subject: [PATCH v4] x86, kaslr: Get kaslr_enabled back correctly

commit f47233c2d34f ("x86/mm/ASLR: Propagate base load address calculation")
is using address as value for kaslr_enabled.

That will get wrong value back for kaslr_enabled in kernel stage.
1. When kaslr is not enabled at boot/choose_kernel_location, if kaslr_enabled
get set wrongly in setup.c, late in module.c::get_module_load_offset
will return not wanted random module load offset.
That change behavior when HIBERNATION is defined or nokaslr is passed.

2. When kaslr is enabled at boot/choose_kernel_location, if kaslr_enabled
get cleared wrongly in setup.c, late in module.c::get_module_load_offset
will not return wanted random module load offset.

This patch changes the code to use early_memmap and access the value,
and will keep boot and kernel consistent with kaslr.

-v3: add checking return from early_memmap according to bp.

Fixes: f47233c2d34f ("x86/mm/ASLR: Propagate base load address calculation")
Cc: Matt Fleming <matt.fleming@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Kees Cook <keescook@chromium.org>
Cc: Jiri Kosina <jkosina@suse.cz>
Acked-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/setup.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -429,7 +429,18 @@ static void __init reserve_initrd(void)

 static void __init parse_kaslr_setup(u64 pa_data, u32 data_len)
 {
-    kaslr_enabled = (bool)(pa_data + sizeof(struct setup_data));
+    /* kaslr_setup_data is defined in aslr.c */
+    unsigned char *data;
+    unsigned long offset = sizeof(struct setup_data);
+
+    data = early_memremap(pa_data, offset + 1);
+    if (!data) {
+        kaslr_enabled = true;
+        return;
+    }
+
+    kaslr_enabled = *(data + offset);
+    early_memunmap(data, offset + 1);
 }

 static void __init parse_setup_data(void)
