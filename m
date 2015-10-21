From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v2] x86/mm: warn on W+x mappings
Date: Wed, 21 Oct 2015 15:24:31 +0200
Message-ID: <20151021132430.GD3575@pd.tnic>
References: <20151012124113.GD2579@codeblueprint.co.uk>
 <20151012124936.GA6260@gmail.com>
 <20151012125548.GE2579@codeblueprint.co.uk>
 <20151012141754.GA6621@gmail.com>
 <20151012144928.GF2579@codeblueprint.co.uk>
 <20151014151807.GA27013@gmail.com>
 <20151014210257.GF2782@codeblueprint.co.uk>
 <20151021094242.GA12155@gmail.com>
 <20151021124924.GA19262@gmail.com>
 <CAKv+Gu92iMzCq0zZfTBUVKfXQqDiVfO3WPiHVWNOYtGjTvOkmQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu92iMzCq0zZfTBUVKfXQqDiVfO3WPiHVWNOYtGjTvOkmQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Ingo Molnar <mingo@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Stephen Smalley <sds@tycho.nsa.gov>, "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Andy Lutomirski <luto@kernel.org>, Denys Vlasenko <dvlasenk@redhat.com>, Brian Gerst <brgerst@gmail.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Oct 21, 2015 at 02:57:47PM +0200, Ard Biesheuvel wrote:
> ... For the remaining cases, which is the vast majority, no such
> assumptions can be made, and since the UEFI runtime regions are
> typically populated with a bunch of PE/COFF images (each of which
> consists of text + data), inferring where the boundaries are between
> them does not seem tractable (for instance, to only map 'boundary'
> pages RWX)

How much of a problem would it be if we still do the on-demand page
faulting and map a trailing piece of code together with the data in a
page RWX?

Still better than mapping the *whole* thing RWX, no?

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
