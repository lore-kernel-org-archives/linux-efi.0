From: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [RFC Part1 PATCH v3 03/17] x86/mm: Secure Encrypted
 Virtualization (SEV) support
Date: Thu, 27 Jul 2017 15:39:27 +0200
Message-ID: <20170727133927.GC28553@nazgul.tnic>
References: <20170724190757.11278-1-brijesh.singh@amd.com>
 <20170724190757.11278-4-brijesh.singh@amd.com>
 <20170726042840.GB30702@nazgul.tnic>
 <facf3ac6-ebda-57a7-f961-6029b3ac7be7@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <facf3ac6-ebda-57a7-f961-6029b3ac7be7-5C7GfCeVMHo@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Cc: Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Piotr Luc <piotr.luc-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Reza Arbab <arbab-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "Kirill A . Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Eric
List-Id: linux-efi@vger.kernel.org

On Wed, Jul 26, 2017 at 11:47:32AM -0500, Tom Lendacky wrote:
> If it's made static then the sme_active()/sev_active() inline functions
> would need to be turned into functions within the mem_encrypt.c file. So
> there's a trade-off to do that, which is the better one?

Simple: why do we have functions if the variables are exported?

The reasoning for sme_me_mask is more or less obvious but for sev_enabled...

IOW, either make the bool static and unlinine the function - this way
you're free to change how you determine whether SEV is enabled later as
callers will be using the function.

Or, if it doesn't really matter because you can always change callers
later, simply drop sev_active() the function and use a bool sev_active
everywhere.

> The kernel needs to distinguish between running under SME and running
> under SEV. SME and SEV are similar but not the same. The trampoline code
> is a good example.  Before paging is activated, SME will access all
> memory as decrypted, but SEV will access all memory as encrypted.  So
> when APs are being brought up under SME the trampoline area cannot be
> encrypted, whereas under SEV the trampoline area must be encrypted.

I guess you're sensing by now that we need this clarification in a
comment above it...

:-)

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
