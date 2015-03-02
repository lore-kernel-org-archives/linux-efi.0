From: Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 1/8] x86, kaslr: get kaslr_enabled back correctly
Date: Mon, 2 Mar 2015 21:25:08 +0100
Message-ID: <20150302202507.GD17532@pd.tnic>
References: <20150301152351.GA17391@gmail.com>
 <CAE9FiQV7DouV+76mzH0jFjFJOFBm-ZmgKpYVjTGAmKao0y3HbA@mail.gmail.com>
 <20150301194904.GC7748@pd.tnic>
 <CAE9FiQVpWQ1NU5Euy2G4btS=94qKCZZ7T0YFsCR1x6iv4C1hjA@mail.gmail.com>
 <20150301202938.GD7748@pd.tnic>
 <CAE9FiQWqfpCg5reKP5TOv=8qJCLxqBDHCKAexH94avZ4b3=irQ@mail.gmail.com>
 <20150302085654.GA17532@pd.tnic>
 <CAE9FiQVS0ai2k-WNfsbwvOkj8YUxzaZJN5XDTMu1Ukhot7zOTw@mail.gmail.com>
 <20150302145313.GC17532@pd.tnic>
 <CAE9FiQV-xSqi-KqgafFL87epGobKmz6Ci_ood3ZtDSFPgSuG6Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAE9FiQV-xSqi-KqgafFL87epGobKmz6Ci_ood3ZtDSFPgSuG6Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Jiri Kosina <jkosina@suse.cz>, Kees Cook <keescook@chromium.org>, Matt Fleming <matt.fleming@intel.com>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Mar 02, 2015 at 10:58:23AM -0800, Yinghai Lu wrote:
> On Mon, Mar 2, 2015 at 6:53 AM, Borislav Petkov <bp@suse.de> wrote:
> > Well, it seems to work here but it still doesn't look reliable enough to
> > me. And this addon_zo thing of arbitrary 256K is strange.
> 
> Thanks for check that out.
> 
> That is not arbitrary number. Need to make that bigger than _end - _rodata
> 
> > objdump -t arch/x86/boot/compressed/vmlinux | grep \ _end
> 0000000000996000 g       .pgtable    0000000000000000 _end
> > objdump -t arch/x86/boot/compressed/vmlinux | grep \ _rodata
> 0000000000981780 g       .rodata    0000000000000000 _rodata
> 
> We only get that size after arch/x86/boot/compressed/vmlinux
> 
> but need number during building kernel vmlinux.
> 
> other way would be just increase init_size in arch/x86/boot/header.S
> instead of put it BRK area.

Ok, I'll take a look at this more tomorrow, on a clear head, but why
can't we make a special, explicit section which is not touched by
the early decompression and relocation code and which we can use for
setup_data only?

IOW, something like that although that doesn't work yet:

---
diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
index 7083c16cccba..01d5ddf1d22f 100644
--- a/arch/x86/boot/compressed/aslr.c
+++ b/arch/x86/boot/compressed/aslr.c
@@ -14,12 +14,12 @@
 static const char build_str[] = UTS_RELEASE " (" LINUX_COMPILE_BY "@"
 		LINUX_COMPILE_HOST ") (" LINUX_COMPILER ") " UTS_VERSION;
 
-struct kaslr_setup_data {
-	__u64 next;
-	__u32 type;
-	__u32 len;
-	__u8 data[1];
-} kaslr_setup_data;
+extern char _setup_data[];
+struct setup_data __attribute__((section (".setup_data"))) ksd = {
+	.type	= SETUP_KASLR,
+	.len	= 1,
+	.next	= 0,
+};
 
 #define I8254_PORT_CONTROL	0x43
 #define I8254_PORT_COUNTER0	0x40
@@ -306,10 +306,7 @@ static void add_kaslr_setup_data(struct boot_params *params, __u8 enabled)
 {
 	struct setup_data *data;
 
-	kaslr_setup_data.type = SETUP_KASLR;
-	kaslr_setup_data.len = 1;
-	kaslr_setup_data.next = 0;
-	kaslr_setup_data.data[0] = enabled;
+	ksd.data[0] = enabled;
 
 	data = (struct setup_data *)(unsigned long)params->hdr.setup_data;
 
@@ -317,10 +314,9 @@ static void add_kaslr_setup_data(struct boot_params *params, __u8 enabled)
 		data = (struct setup_data *)(unsigned long)data->next;
 
 	if (data)
-		data->next = (unsigned long)&kaslr_setup_data;
+		data->next = (unsigned long)&ksd;
 	else
-		params->hdr.setup_data = (unsigned long)&kaslr_setup_data;
-
+		params->hdr.setup_data = (unsigned long)&ksd;
 }
 
 unsigned char *choose_kernel_location(struct boot_params *params,
diff --git a/arch/x86/boot/compressed/vmlinux.lds.S b/arch/x86/boot/compressed/vmlinux.lds.S
index 34d047c98284..26d62f4b27b9 100644
--- a/arch/x86/boot/compressed/vmlinux.lds.S
+++ b/arch/x86/boot/compressed/vmlinux.lds.S
@@ -29,6 +29,10 @@ SECTIONS
 	.rodata..compressed : {
 		*(.rodata..compressed)
 	}
+	.setup_data : {
+		_setup_data = . ;
+		*(.setup_data)
+	}
 	.text :	{
 		_text = .; 	/* Text */
 		*(.text)
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 98dc9317286e..0978c61f84bd 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -429,7 +429,11 @@ static void __init reserve_initrd(void)
 
 static void __init parse_kaslr_setup(u64 pa_data, u32 data_len)
 {
-	kaslr_enabled = (bool)(pa_data + sizeof(struct setup_data));
+	struct setup_data *kdata;
+
+	kdata = early_memremap(pa_data, data_len);
+	kaslr_enabled = kdata->data[0];
+	early_iounmap(kdata, data_len);
 }
 
 static void __init parse_setup_data(void)

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
