From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: EFI pstore: BUG: scheduling while atomic, and possible circular
 locking dependency
Date: Mon, 26 Nov 2012 17:50:57 +0000
Message-ID: <1353952257.2560.111.camel@mfleming-mobl1.ger.corp.intel.com>
References: <50AD94A4.4030100@redhat.com>
	 <20121122041239.GA24623@lizard.sbx14280.paloaca.wayport.net>
	 <A5ED84D3BB3A384992CBB9C77DEDA4D4149FA32A@USINDEM103.corp.hds.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D4149FA32A-ohthHghroY0jroPwUH3sq+6wyyQG6/Uh@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
Cc: Anton Vorontsov <anton.vorontsov-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 2012-11-26 at 17:06 +0000, Seiji Aguchi wrote:
> Matt,
> 
> Your tree below can be built successfully.
> Could you please fix it?
> I would like to check if efivarfs ,which replaces with sysfs files, works correctly.
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git
> 
> 
>   CHK     include/generated/uapi/linux/version.h
>   CHK     include/generated/utsrelease.h
>   CALL    scripts/checksyscalls.sh
>   CHK     include/generated/compile.h
>   CC      arch/x86/platform/efi/efi.o
>   CC      arch/x86/platform/efi/efi_64.o
>   LD      arch/x86/platform/iris/built-in.o
>   CC      arch/x86/mm/physaddr.o
>   CC      kernel/panic.o
>   LD      arch/x86/platform/mrst/built-in.o
>   CC      kernel/printk.o
>   CC      arch/x86/realmode/rm/video-vga.o
> arch/x86/platform/efi/efi.c:719:1: error: unterminated #ifdef
> arch/x86/platform/efi/efi.c: In function 'efi_init':
> arch/x86/platform/efi/efi.c:718: error: expected declaration or statement at end of input
> make[3]: *** [arch/x86/platform/efi/efi.o] Error 1
> make[3]: *** Waiting for unfinished jobs....

Eek - merge botch. Fixed now, thanks.
