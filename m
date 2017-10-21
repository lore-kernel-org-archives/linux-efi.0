From: joeyli <jlee@suse.com>
Subject: Re: [PATCH 12/27] x86/msr: Restrict MSR access when the kernel is
 locked down
Date: Sat, 21 Oct 2017 12:39:19 +0800
Message-ID: <20171021043919.GF3285@linux-l9pv.suse>
References: <20171020190939.569cedd2@alans-desktop>
 <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk>
 <150842472452.7923.2592278090192179002.stgit@warthog.procyon.org.uk>
 <18499.1508532496@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18499.1508532496@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Alan Cox <gnomes@lxorguk.ukuu.org.uk>, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, matthew.garrett@nebula.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, jforbes@redhat.com
List-Id: linux-efi@vger.kernel.org

On Fri, Oct 20, 2017 at 09:48:16PM +0100, David Howells wrote:
> Alan Cox <gnomes@lxorguk.ukuu.org.uk> wrote:
> 
> > There are a load of standard tools that use this so I think you are going
> > to need a whitelist. Can you at least log *which* MSR in the failing case
> > so a whitelist can be built over time ?
> 
[...snip]
> 
> And do you know where wrmsr_safe_regs() might be found?  I can see things
> using it and exporting it, but no implementation, so I'm guessing it's
> macroised somewhere.

Looks the definition is in 

arch/x86/lib/msr-reg.S

#ifdef CONFIG_X86_64
/*
 * int {rdmsr,wrmsr}_safe_regs(u32 gprs[8]);
 *
 * reg layout: u32 gprs[eax, ecx, edx, ebx, esp, ebp, esi, edi]
 *
 */
.macro op_safe_regs op
ENTRY(\op\()_safe_regs)
        pushq %rbx
        pushq %r12
...

Regards
Joey Lee
