From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v5 06/10] x86/asm/efi: Fix asmvalidate warnings for
 efi_stub_64.S
Date: Thu, 11 Jun 2015 14:14:39 +0100
Message-ID: <20150611131438.GB19243@codeblueprint.co.uk>
References: <cover.1433937132.git.jpoimboe@redhat.com>
 <3e1d9ce523b3174a49b4317cd8b1b85dfd0c319a.1433937132.git.jpoimboe@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3e1d9ce523b3174a49b4317cd8b1b85dfd0c319a.1433937132.git.jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Michal Marek <mmarek-AlSwsSmVLrQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, 10 Jun, at 07:06:14AM, Josh Poimboeuf wrote:
> Fix the following asmvalidate warnings:
> 
>    asmvalidate: arch/x86/platform/efi/efi_stub_64.o: efi_call(): missing FP_SAVE/RESTORE macros
>    asmvalidate: arch/x86/boot/compressed/efi_stub_64.o: efi_call(): missing FP_SAVE/RESTORE macros
> 
> efi_call() is a non-leaf callable function, so save/restore the frame
> pointer with FP_SAVE/RESTORE.
> 
> Signed-off-by: Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> ---
>  arch/x86/platform/efi/efi_stub_64.S | 3 +++
>  1 file changed, 3 insertions(+)

Yeah, fair enough. Though it's worth noting that because we're calling
firmware functions, which use the Microsoft ABI, %rbp will be saved by
the callee function if used. Anyway,

Acked-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

And since I know Boris in particular has poked around in this area, an
ACK from him would be worth alot.

-- 
Matt Fleming, Intel Open Source Technology Center
