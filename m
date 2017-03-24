From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2] x86/mm/KASLR: EFI region is mistakenly included into
 KASLR VA space for randomization
Date: Fri, 24 Mar 2017 11:54:52 +0100
Message-ID: <20170324105452.GA20282@gmail.com>
References: <1490331592-31860-1-git-send-email-bhe@redhat.com>
 <20170324080833.GA15200@gmail.com>
 <20170324083451.GC30442@x1>
 <20170324084609.GA6807@dhcp-128-65.nay.redhat.com>
 <20170324092433.GA3237@gmail.com>
 <CAKv+Gu_V_VAWuDtKyOY9RS+cdhi+c5z2a7n2kcXVybvvdmPYBw@mail.gmail.com>
 <20170324103624.GA6231@gmail.com>
 <CAKv+Gu-d3M6-T1HbZYjFnPA_KYtdQyCx36fRSXD5vNurjAqXuw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-d3M6-T1HbZYjFnPA_KYtdQyCx36fRSXD5vNurjAqXuw@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Dave Young <dyoung@redhat.com>, Baoquan He <bhe@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Thomas Garnier <thgarnie@google.com>, Kees Cook <keescook@chromium.org>, Borislav Petkov <bp@alien8.de>, Andrew Morton <akpm@linux-foundation.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Bhupesh Sharma <bhsharma@redhat.com>
List-Id: linux-efi@vger.kernel.org


* Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:

> > Turning KASLR off actively degrades that randomization of the kernel virtual 
> > addresses.
> >
> > Am I missing anything?
> >
> 
> No, I think you are right. UEFI runtime services region are likely to consist of 
> R+W+X mappings for the foreseeable future on x86, and the more we tighten down 
> security in other places, the more appealing the UEFI regions become for 
> exploitation (even if they are only mapped while runtime services calls are in 
> progress).

Ok, so I'm fine with the current proposed patch as a temporary workaround, but 
only if we are going to get a real fix as well, ASAP.

Thanks,

	Ingo
