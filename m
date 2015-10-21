From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v2] x86/mm: warn on W+x mappings
Date: Wed, 21 Oct 2015 16:36:51 +0200
Message-ID: <20151021143651.GE3575@pd.tnic>
References: <20151012125548.GE2579@codeblueprint.co.uk>
 <20151012141754.GA6621@gmail.com>
 <20151012144928.GF2579@codeblueprint.co.uk>
 <20151014151807.GA27013@gmail.com>
 <20151014210257.GF2782@codeblueprint.co.uk>
 <20151021094242.GA12155@gmail.com>
 <20151021124924.GA19262@gmail.com>
 <CAKv+Gu92iMzCq0zZfTBUVKfXQqDiVfO3WPiHVWNOYtGjTvOkmQ@mail.gmail.com>
 <20151021132430.GD3575@pd.tnic>
 <CAKv+Gu9GaLbexayuT81gM5=081a1gT57RaY_HiCzh9YYvy5SGg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9GaLbexayuT81gM5=081a1gT57RaY_HiCzh9YYvy5SGg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Ingo Molnar <mingo@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Stephen Smalley <sds@tycho.nsa.gov>, "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Andy Lutomirski <luto@kernel.org>, Denys Vlasenko <dvlasenk@redhat.com>, Brian Gerst <brgerst@gmail.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Oct 21, 2015 at 03:28:56PM +0200, Ard Biesheuvel wrote:
> In theory, yes. In practice, since this is supposed to be a security
> enhancement, we need some kind of ground truth to tell us which pages
> can be legally modified *and* executed, so that we can detect the
> illegal cases. My point was that, since a multitude of PE/COFF images
> can be covered by a single EfiRuntimeServicesCode region, the UEFI
> memory map does not give us enough information to make the distinction
> between a page that sits on the text/data boundary of some PE/COFF
> image and a page that sits wholly in either.

Well, we're going to simply allow the accesses to in-kernel users which
fault on those ranges, assuming that in-kernel modifiers are legit and
DTRT. Which means, we don't really need to know which pages can be
legally modified - we simply trust the in-kernel users.

The moment you're able to load an evil kernel module, guarding against
those writes is the last thing you need to worry about...

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
