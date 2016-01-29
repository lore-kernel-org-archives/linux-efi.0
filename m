From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: issue with MEMBLOCK_NOMAP
Date: Fri, 29 Jan 2016 15:06:33 +0100
Message-ID: <CAKv+Gu97eRFX80+mvFpv85Zc0=B=aa-LXM6KcNAQ+6Kxz3ZTZQ@mail.gmail.com>
References: <1454076020.2821.39.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1454076020.2821.39.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Langsdorf <mlangsdo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 29 January 2016 at 15:00, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Hi Ard,
>
> I ran into an issue with your MEMBLOCK_NOMAP changes on a particular
> firmware. The symptom is the kernel panics at boot time when it hits
> an unmapped page while unpacking the initramfs. As it turns out, the
> start of the initramfs shares a 64k kernel page with the UEFI memmap.
> I can avoid the problem with:
>
> @@ -203,7 +203,7 @@ void __init efi_init(void)
>
>         reserve_regions();
>         early_memunmap(memmap.map, params.mmap_size);
> -       memblock_mark_nomap(params.mmap & PAGE_MASK,
> -                           PAGE_ALIGN(params.mmap_size +
> -                                      (params.mmap & ~PAGE_MASK)));
> +       memblock_reserve(params.mmap & PAGE_MASK,
> +                        PAGE_ALIGN(params.mmap_size +
> +                                   (params.mmap & ~PAGE_MASK)));
>  }
>
>
> But it makes me worry about the same potential problem with
> other reserved regions which we nomap. What do you think?
>

So I take it this initramfs allocation is not made by the stub but by
GRUB? Since the stub rounds all allocations to 64 KB ...

In any case, regardless of the underlying cause, if any part of the
initramfs turns out not to be covered by the linear mapping, we should
invoke your code to move it. So I think it should be a matter of
refining the logic in relocate_initrd() to do the right thing in this
case

Your suggested change will break 32-bit ARM, since we use
ioremap_nocache() to map the UEFI memory map, and ARM does not allow
that on ranges that are part of the linear mapping.

-- 
Ard.
