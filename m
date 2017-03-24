From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v2] x86/mm/KASLR: EFI region is mistakenly included into
 KASLR VA space for randomization
Date: Fri, 24 Mar 2017 10:36:15 +0100
Message-ID: <20170324093615.ac4gf5odamcdxjnw@pd.tnic>
References: <1490331592-31860-1-git-send-email-bhe@redhat.com>
 <20170324080833.GA15200@gmail.com>
 <20170324083451.GC30442@x1>
 <20170324084609.GA6807@dhcp-128-65.nay.redhat.com>
 <20170324092433.GA3237@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170324092433.GA3237@gmail.com>
Sender: stable-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Dave Young <dyoung@redhat.com>, Baoquan He <bhe@redhat.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-efi@vger.kernel.org, Thomas Garnier <thgarnie@google.com>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Bhupesh Sharma <bhsharma@redhat.com>
List-Id: linux-efi@vger.kernel.org

On Fri, Mar 24, 2017 at 10:24:34AM +0100, Ingo Molnar wrote:
> Preserving virtual addresses for kexec is a red herring: the randomized offset 
> could be passed to the kexec-ed kernel just fine.

Not only that - kexec'ed kernel gets the addresses from sysfs so we can randomize.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
