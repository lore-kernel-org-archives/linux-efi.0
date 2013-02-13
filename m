From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: Lock down MSR writing in secure boot
Date: Wed, 13 Feb 2013 09:21:05 -0800
Message-ID: <511BCB81.1010907@zytor.com>
References: <dee64752-850c-4d78-b703-f47a985bc13e@email.android.com>    <CAGXu5jLAufTRm=sDST0br_WEkn4o0Hpjv2jDP2Na=cCvuM+MGg@mail.gmail.com>    <1360355671.18083.18.camel@x230.lan>    <CAGXu5jKo2PfMBO4A0ZgQcrPuj8OHNaff+CjAesOAWkZc0vB9+Q@mail.gmail.com>    <51157C9C.6030501@zytor.com> <20130208230655.GB28990@pd.tnic>    <1360366012.18083.21.camel@x230.lan> <5115A4CC.3080102@zytor.com>    <1360373383.18083.23.camel@x230.lan>    <CAGXu5j+xvJ3L5ejxtZ-Jw3F6rV7OsrE0_HZCGu_er0rH2_PwKA@mail.gmail.com>    <20130209092925.GA17728@pd.tnic> <1360422712.18083.24.camel@x230.lan>   <511AE2CC.5040705@zytor.com> <1360733962.18083.30.camel@x230.lan>  <511B2EB9.5070406@zytor.com> <1360736860.18083.33.camel@x230.lan> <511B33BC.9080307@zytor.com> <511B4E61.1040604@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <511B4E61.1040604@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>, Borislav Petkov <bp@alien8.de>, Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On 02/13/2013 12:27 AM, Paolo Bonzini wrote:
>
> On non-x86 machines CAP_SYS_RAWIO is much less dangerous, especially
> when coupled with file DAC.
>

"File DAC"?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.
