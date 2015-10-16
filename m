From: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Subject: Re: [PATCH v2] x86/mm: warn on W+x mappings
Date: Thu, 15 Oct 2015 18:45:19 -0700
Message-ID: <1444959919.28005.26.camel@ranerica-desk01>
References: <20151012113605.GB7384@pd.tnic>
	 <20151012124113.GD2579@codeblueprint.co.uk>
	 <20151012124936.GA6260@gmail.com>
	 <20151012125548.GE2579@codeblueprint.co.uk>
	 <20151012141754.GA6621@gmail.com>
	 <20151012144928.GF2579@codeblueprint.co.uk>
	 <20151014151807.GA27013@gmail.com>
	 <CALCETrU-_dJ3=+1nHN82mE==YpXGB8USWdrXDc=BVk_J5UdN3A@mail.gmail.com>
	 <20151014153522.GC8218@pd.tnic> <20151015101016.GB2975@codeblueprint.co.uk>
	 <20151015103332.GE4267@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151015103332.GE4267@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@kernel.org>, Stephen Smalley <sds@tycho.nsa.gov>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Andy Lutomirski <luto@kernel.org>, Denys Vlasenko <dvlasenk@redhat.com>, Brian Gerst <brgerst@gmail.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, luv@lists.01.org
List-Id: linux-efi@vger.kernel.org

On Thu, 2015-10-15 at 12:33 +0200, Borislav Petkov wrote:
> Yeah, that's actually a good idea. Why not upstream it for the wider
> audience so that people can actually start reporting b0rked UEFIs?
> With
> a big and nice FW_BUG splat in there...

We attempted to upstream in the past but later I discovered that my
implementation in particular is causing warnings due to SMP. Also, I
need to implement an alternative or extension to the current
efi_map_region, which have the __init qualifier. This is because
mappings might happen after the __inits have been discarded. I have this
work currently in my scope.

Thanks and BR,
Ricardo
