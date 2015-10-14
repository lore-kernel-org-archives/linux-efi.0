From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v2] x86/mm: warn on W+x mappings
Date: Wed, 14 Oct 2015 17:35:22 +0200
Message-ID: <20151014153522.GC8218@pd.tnic>
References: <20151006073205.GA11115@gmail.com>
 <5613EAD5.2070405@tycho.nsa.gov>
 <20151012113605.GB7384@pd.tnic>
 <20151012124113.GD2579@codeblueprint.co.uk>
 <20151012124936.GA6260@gmail.com>
 <20151012125548.GE2579@codeblueprint.co.uk>
 <20151012141754.GA6621@gmail.com>
 <20151012144928.GF2579@codeblueprint.co.uk>
 <20151014151807.GA27013@gmail.com>
 <CALCETrU-_dJ3=+1nHN82mE==YpXGB8USWdrXDc=BVk_J5UdN3A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrU-_dJ3=+1nHN82mE==YpXGB8USWdrXDc=BVk_J5UdN3A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Ingo Molnar <mingo@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Stephen Smalley <sds@tycho.nsa.gov>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Andy Lutomirski <luto@kernel.org>, Denys Vlasenko <dvlasenk@redhat.com>, Brian Gerst <brgerst@gmail.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Oct 14, 2015 at 08:30:48AM -0700, Andy Lutomirski wrote:
> Can we just unmap these things until someone tries to do an EFI call,
> and then unmap them again after the call returns?  We already switch
> pgds for EFI IIRC.

hpa did mention an EFI-aware page fault handler at the time. I guess we
could do that too...

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
