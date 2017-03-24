From: Baoquan He <bhe@redhat.com>
Subject: Re: [PATCH v2] x86/mm/KASLR: EFI region is mistakenly included into
 KASLR VA space for randomization
Date: Fri, 24 Mar 2017 19:52:33 +0800
Message-ID: <20170324115233.GA23558@x1>
References: <1490331592-31860-1-git-send-email-bhe@redhat.com>
 <20170324080833.GA15200@gmail.com>
 <20170324083451.GC30442@x1>
 <20170324084609.GA6807@dhcp-128-65.nay.redhat.com>
 <20170324092433.GA3237@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170324092433.GA3237@gmail.com>
Sender: stable-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Dave Young <dyoung@redhat.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-efi@vger.kernel.org, Thomas Garnier <thgarnie@google.com>, Kees Cook <keescook@chromium.org>, Borislav Petkov <bp@alien8.de>, Andrew Morton <akpm@linux-foundation.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Bhupesh Sharma <bhsharma@redhat.com>
List-Id: linux-efi@vger.kernel.org

On 03/24/17 at 10:24am, Ingo Molnar wrote:
> 
> * Dave Young <dyoung@redhat.com> wrote:
> 
> > > > So I applied this kexec fix and extended the changelog to clearly show why 
> > > > this fix matters in practice.
> > > 
> > > I thought it only impacts kexec, but Dave thought it will impact 1st kenrel 
> > > either.
> > 
> > Yes, I think no need to mention kexec, it is a general issue.
> > 
> > First, the space is reserved for EFI, so kernel should not use it for kaslr. 
> 
> It's the kernel's EFI code, and we map whatever address we want (and then pass 
> that to the EFI runtime), so wether it's randomized or not is the Linux kernel's 
> policy decision...
> 
> So that's my question: can these memory regions include security sensitive data, 
> and if yes, how can we best randomize it while kexec and other kernel and EFI 
> features still work?

It doesn't corrupt kernel possibly because:
1) there's espfixup stack region between them if CONFIG_X86_ESPFIX64 is
enabled, then the upper limit of kaslr VA space for randomization could be
ESPFIX_BASE_ADDR. Fedora default to enable ESPFIX_BASE_ADDR.

ffffe90000000000 - ffffe9ffffffffff (=40 bits) hole
ffffea0000000000 - ffffeaffffffffff (=40 bits) virtual memory map (1TB)
... unused hole ...
ffffec0000000000 - fffffbffffffffff (=44 bits) kasan shadow memory (16TB)
... unused hole ...
ffffff0000000000 - ffffff7fffffffff (=39 bits) %esp fixup stacks                                                                                 
... unused hole ...
ffffffef00000000 - fffffffeffffffff (=64 GB) EFI region mapping space

2) Though ESPFIX_BASE_ADDR is disabled, efi region is included into
kaslr mm va space, efi is allocated top-down in 64G, while vmemmap is 1T
large and allocated bottom-up, it rarely used up 1TB space to map struct
page.

3) most of the time, it might not randomize vmemmap to occupy the efi
region.

So up to now, no corruption is heard about this bug.

Thanks
Baoquan
