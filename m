From: =?UTF-8?Q?M=c3=b4she_van_der_Sterre?= <me-A/3C56C7qwM@public.gmane.org>
Subject: Re: BGRT doesn't work for me on efi-next
Date: Sun, 20 Dec 2015 20:24:56 +0100
Message-ID: <56770088.8000301@moshe.nl>
References: <5665E8E0.4050203@moshe.nl> <20151207204451.GC16222@cloud>
 <56660979.5080204@moshe.nl> <20151207235520.GA17617@cloud>
 <566623B3.8010104@moshe.nl> <20151208023443.GA10087@x>
 <56664F79.6060100@moshe.nl> <20151208140529.GH2518@codeblueprint.co.uk>
 <5667E7B5.3080705@moshe.nl> <5672E335.8000004@moshe.nl>
 <20151218125628.GA2638@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151218125628.GA2638-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Sai Praneeth <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 12/18/2015 01:56 PM, Matt Fleming wrote:
> (Pulling in Ingo and Juergen because of commit 954e12f7a800)
>
> On Thu, 17 Dec, at 05:30:45PM, M=F4she van der Sterre wrote:
>> Hello Sai and others,
>>
>> The change to use early_mem*() instead of early_io*() in 50a0cb56 do=
es not
>> work on my machine. Last week I discussed some BGRT changes and I cr=
eated a
>> patch for that, but can't test it on efi-next because of this.
>>
>> I get this (when booting 50a0cb56, without any of my changes):
>> [    0.026936] ------------[ cut here ]------------
>> [    0.026941] WARNING: CPU: 0 PID: 0 at mm/early_ioremap.c:137
>> __early_ioremap+0x102/0x1bb()
>> [    0.026941] Modules linked in:
>> [    0.026944] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.4.0-rc1 #=
2
>> [    0.026945] Hardware name: Dell Inc. XPS 13 9343/09K8G1, BIOS A05
>> 07/14/2015
>> [    0.026946]  0000000000000000 900f03d5a116524d ffffffff81c03e60
>> ffffffff813a3fff
>> [    0.026948]  0000000000000000 ffffffff81c03e98 ffffffff810a0852
>> 00000000d7b76000
>> [    0.026949]  0000000000000000 0000000000000001 0000000000000001
>> 000000000000017c
>> [    0.026951] Call Trace:
>> [    0.026955]  [<ffffffff813a3fff>] dump_stack+0x44/0x55
>> [    0.026958]  [<ffffffff810a0852>] warn_slowpath_common+0x82/0xc0
>> [    0.026959]  [<ffffffff810a099a>] warn_slowpath_null+0x1a/0x20
>> [    0.026961]  [<ffffffff81d8c395>] __early_ioremap+0x102/0x1bb
>> [    0.026962]  [<ffffffff81d8c602>] early_memremap+0x13/0x15
>> [    0.026964]  [<ffffffff81d78361>] efi_bgrt_init+0x162/0x1ad
>> [    0.026966]  [<ffffffff81d778ec>] efi_late_init+0x9/0xb
>> [    0.026968]  [<ffffffff81d58ff5>] start_kernel+0x46f/0x49f
>> [    0.026970]  [<ffffffff81d58120>] ? early_idt_handler_array+0x120=
/0x120
>> [    0.026972]  [<ffffffff81d58339>] x86_64_start_reservations+0x2a/=
0x2c
>> [    0.026974]  [<ffffffff81d58485>] x86_64_start_kernel+0x14a/0x16d
>> [    0.026977] ---[ end trace f9b3812eb8e24c58 ]---
>> [    0.026978] efi_bgrt: Ignoring BGRT: failed to map image memory
>>
>> This is the second early_memremap call in efi_bgrt_init triggering
>> WARN_ON(nrpages > NR_FIX_BTMAPS). Can you comment on this?
> Hmm... yeah NR_FIX_BTMAPS =3D=3D 64, so early_memremap() is limited t=
o
> mapping ~200KB at once. That's not very big, your BGRT data is likely
> much larger than that.
>
> Obviously we can't use efi_lookup_mapped_addr() any more, so it makes
> sense to come up with a much robust way to memremap the BGRT image.
>
> The immediate solution that comes to mind is using memremap() instead
> of the early_* version, since the late version won't use the FIXMAP
> area and will allow us to map a much larger region into the kernel
> virtual address space.
>
> Digging through the history it appears I was the one who made the
> switch from ioremap() to early_memremap() in commit 081cd62a010f
> ("x86/efi: Allow mapping BGRT on x86-32"), which I suspect was becaus=
e
> a generic memremap() implementation didn't exist at the time. Dan
> Williams introduced one in Aug 2015 with commit 92281dee825f ("arch:
> introduce memremap()").
>
> Somewhat surprisingly, Juergen switched the BGRT driver from
> early_memremap() to early_ioremap() in commit 954e12f7a800 ("x86/mm,
> efi: Use early_ioremap() in arch/x86/platform/efi/efi-bgrt.c")
> although I can't figure out why because this isn't I/O memory. And no=
w
> we're attempting to switch it back.
>
> Juergen, could you provide a rationale for commit 954e12f7a800? All
> the commit message says is that it's "an I/O-area", but that isn't
> true.
>
> In the meantime M=F4she, could you try this patch ontop of the EFI
> 'next' branch? (Note it may not work/compile, but you get the gist)

The patch works on my laptop

> ---
>
> diff --git a/arch/x86/platform/efi/efi-bgrt.c b/arch/x86/platform/efi=
/efi-bgrt.c
> index bf51f4c02562..b0970661870a 100644
> --- a/arch/x86/platform/efi/efi-bgrt.c
> +++ b/arch/x86/platform/efi/efi-bgrt.c
> @@ -72,14 +72,14 @@ void __init efi_bgrt_init(void)
>   		return;
>   	}
>  =20
> -	image =3D early_memremap(bgrt_tab->image_address, sizeof(bmp_header=
));
> +	image =3D memremap(bgrt_tab->image_address, sizeof(bmp_header), MEM=
REMAP_WB);
>   	if (!image) {
>   		pr_err("Ignoring BGRT: failed to map image header memory\n");
>   		return;
>   	}
>  =20
>   	memcpy(&bmp_header, image, sizeof(bmp_header));
> -	early_memunmap(image, sizeof(bmp_header));
> +	memunmap(image);
>   	bgrt_image_size =3D bmp_header.size;
>  =20
>   	bgrt_image =3D kmalloc(bgrt_image_size, GFP_KERNEL | __GFP_NOWARN)=
;
> @@ -89,7 +89,7 @@ void __init efi_bgrt_init(void)
>   		return;
>   	}
>  =20
> -	image =3D early_memremap(bgrt_tab->image_address, bmp_header.size);
> +	image =3D memremap(bgrt_tab->image_address, bmp_header.size, MEMREM=
AP_WB);
>   	if (!image) {
>   		pr_err("Ignoring BGRT: failed to map image memory\n");
>   		kfree(bgrt_image);
> @@ -98,5 +98,5 @@ void __init efi_bgrt_init(void)
>   	}
>  =20
>   	memcpy(bgrt_image, image, bgrt_image_size);
> -	early_memunmap(image, bmp_header.size);
> +	memunmap(image);
>   }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" =
in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
