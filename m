From: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: issue with MEMBLOCK_NOMAP
Date: Fri, 29 Jan 2016 09:00:20 -0500
Message-ID: <1454076020.2821.39.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Langsdorf <mlangsdo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi Ard,

I ran into an issue with your MEMBLOCK_NOMAP changes on a particular
firmware. The symptom is the kernel panics at boot time when it hits
an unmapped page while unpacking the initramfs. As it turns out, the
start of the initramfs shares a 64k kernel page with the UEFI memmap.
I can avoid the problem with:

@@ -203,7 +203,7 @@ void __init efi_init(void)
=C2=A0
=C2=A0	reserve_regions();
=C2=A0	early_memunmap(memmap.map, params.mmap_size);
-	memblock_mark_nomap(params.mmap & PAGE_MASK,
-			=C2=A0=C2=A0=C2=A0=C2=A0PAGE_ALIGN(params.mmap_size +
-				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(params.mmap & ~PAGE_MAS=
K)));
+	memblock_reserve(params.mmap & PAGE_MASK,
+			=C2=A0PAGE_ALIGN(params.mmap_size +=C2=A0
+				=C2=A0=C2=A0=C2=A0=C2=A0(params.mmap & ~PAGE_MASK)));
=C2=A0}


But it makes me worry about the same potential problem with
other reserved regions which we nomap. What do you think?

--Mark
