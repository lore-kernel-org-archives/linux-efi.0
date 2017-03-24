From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2] x86/mm/KASLR: EFI region is mistakenly included into
 KASLR VA space for randomization
Date: Fri, 24 Mar 2017 10:24:34 +0100
Message-ID: <20170324092433.GA3237@gmail.com>
References: <1490331592-31860-1-git-send-email-bhe@redhat.com>
 <20170324080833.GA15200@gmail.com>
 <20170324083451.GC30442@x1>
 <20170324084609.GA6807@dhcp-128-65.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170324084609.GA6807@dhcp-128-65.nay.redhat.com>
Sender: stable-owner@vger.kernel.org
To: Dave Young <dyoung@redhat.com>
Cc: Baoquan He <bhe@redhat.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-efi@vger.kernel.org, Thomas Garnier <thgarnie@google.com>, Kees Cook <keescook@chromium.org>, Borislav Petkov <bp@alien8.de>, Andrew Morton <akpm@linux-foundation.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Bhupesh Sharma <bhsharma@redhat.com>
List-Id: linux-efi@vger.kernel.org


* Dave Young <dyoung@redhat.com> wrote:

> > > So I applied this kexec fix and extended the changelog to clearly show why 
> > > this fix matters in practice.
> > 
> > I thought it only impacts kexec, but Dave thought it will impact 1st kenrel 
> > either.
> 
> Yes, I think no need to mention kexec, it is a general issue.
> 
> First, the space is reserved for EFI, so kernel should not use it for kaslr. 

It's the kernel's EFI code, and we map whatever address we want (and then pass 
that to the EFI runtime), so wether it's randomized or not is the Linux kernel's 
policy decision...

So that's my question: can these memory regions include security sensitive data, 
and if yes, how can we best randomize it while kexec and other kernel and EFI 
features still work?

Preserving virtual addresses for kexec is a red herring: the randomized offset 
could be passed to the kexec-ed kernel just fine.

Thanks,

	Ingo
